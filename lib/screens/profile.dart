import 'dart:convert';
import 'dart:io';
import 'package:bank_card/core/service/aposervice.dart';
import 'package:bank_card/presentation/cubit/uploud_image_cubit.dart';
import 'package:bank_card/presentation/cubit/uploud_image_state.dart';
import 'package:bank_card/repository/card.dart';
import 'package:bank_card/widget/botemsheet.dart';
import 'package:bank_card/widget/profile_header.dart';
import 'package:bank_card/widget/showmodelbottemsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:u_credit_card/u_credit_card.dart';

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadCubit(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<Map<String, dynamic>> _userProfileFuture;
  String? _userId;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  void _refreshProfile() {
    setState(() {
      _userProfileFuture = _fetchUserProfile();
    });
  }

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    const storage = FlutterSecureStorage();
    _userId = await storage.read(key: 'userId');

    final url = Uri.parse(
      "${ApiService.baseUrl}/users/me?populate=cards,avatar",
    );
    final response = await ApiService.http.get(url);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception("Profil ma'lumotlarini yuklab bo'lmadi");
    }
  }

  Future<void> _uploadAvatar(File imageFile) async {
    if (_userId == null) return;

    try {
      const storage = FlutterSecureStorage();
      final jwtToken = await storage.read(key: 'jwt');

      final uploadUrl = Uri.parse("${ApiService.baseUrl}/upload");
      var uploadRequest = http.MultipartRequest('POST', uploadUrl);

      if (jwtToken != null) {
        uploadRequest.headers['Authorization'] = 'Bearer $jwtToken';
      }

      uploadRequest.fields['ref'] = 'plugin::users-permissions.user';
      uploadRequest.fields['refId'] = _userId!;
      uploadRequest.fields['field'] = 'avatar';

      var multipartFile = await http.MultipartFile.fromPath(
        'files',
        imageFile.path,
      );
      uploadRequest.files.add(multipartFile);

      var streamedResponse = await uploadRequest.send();
      var uploadResponse = await http.Response.fromStream(streamedResponse);

      if (uploadResponse.statusCode >= 200 && uploadResponse.statusCode < 300) {
        _refreshProfile();
      }
    } catch (e) {
      print("Avatar yangilash xatosi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadCubit, UploudImageState>(
      listener: (context, state) {
        if (state.status == UploudImageStatus.success && state.image != null) {
          _uploadAvatar(state.image!);
        }
      },
      builder: (context, uploadState) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F1115),
          appBar: AppBar(
            title: const Text(
              "Profil",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Stack(
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: _userProfileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      uploadState.status != UploudImageStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white70),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Xatolik: ${snapshot.error}",
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        "Ma'lumot topilmadi",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final userData = snapshot.data!;
                  final username = userData['username'] ?? 'Nomaʼlum';
                  final email = userData['email'] ?? '';

                  String? avatarUrl;
                  if (userData['avatar'] != null) {
                    avatarUrl =
                        ApiService.baseUrl.replaceAll('/api', '') +
                        userData['avatar']['url'];
                  }

                  final List cardsJson = userData['cards'] ?? [];
                  final uniqueCards = <String, CardModel>{};
                  for (var e in cardsJson) {
                    final card = CardModel.fromJson(e);
                    uniqueCards[card.documentId.isNotEmpty
                            ? card.documentId
                            : card.cardnumber.toString()] =
                        card;
                  }
                  final cards = uniqueCards.values.toList();

                  return RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: const Color(0xFF1E222B),
                    onRefresh: () async => _refreshProfile(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileHeader(
                            username: username,
                            email: email,
                            avatarUrl: avatarUrl,
                            localImage: uploadState.image != null
                                ? FileImage(uploadState.image!)
                                : null,
                            isLoading:
                                uploadState.status == UploudImageStatus.loading,
                            onTapAvatar: () =>
                                context.read<UploadCubit>().pickImage(),
                          ),
                          const SizedBox(height: 36),
                          const Text(
                            "Mening kartalarim",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (cards.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 50),
                                child: Text(
                                  "Hozircha kartalar mavjud emas",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              itemCount: cards.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final card = cards[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Draggable<CardModel>(
                                    data: card,
                                    onDragStarted: () =>
                                        setState(() => _isDragging = true),
                                    onDragEnd: (_) =>
                                        setState(() => _isDragging = false),
                                    onDraggableCanceled: (_, __) =>
                                        setState(() => _isDragging = false),
                                    childWhenDragging: SizedBox(),
                                    feedback: Material(
                                      color: Colors.transparent,
                                      child: CreditCardUi(
                                        creditCardType: CreditCardType.visa,
                                        cardHolderFullName: card.holdername,
                                        cardNumber: card.cardnumber.toString(),
                                        validThru: card.expireData.toString(),
                                      ),
                                    ),
                                    child: CreditCardUi(
                                      creditCardType: CreditCardType.visa,
                                      cardHolderFullName: card.holdername,
                                      cardNumber: card.cardnumber.toString(),
                                      validThru: card.expireData.toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // O'chirish Target Button
              if (_isDragging)
                Positioned(
                  top: 10,
                  left: 20,
                  right: 20,
                  child: DragTarget<CardModel>(
                    onAccept: (receivedCard) async {
                      final isDeleted = await showDeleteCardBottomSheet(
                        context,
                        receivedCard,
                      );
                      if (isDeleted == true) _refreshProfile();
                    },
                    builder: (context, candidateData, rejectedData) {
                      return SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: candidateData.isNotEmpty
                                ? const Color(0xFF7E22CE)
                                : const Color(0xFF1A1625),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF7E22CE),
            elevation: 0,
            onPressed: () async {
              final isAdded = await showAddCardBottomSheet(context);
              if (isAdded == true) _refreshProfile();
            },
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
          ),
        );
      },
    );
  }
}
