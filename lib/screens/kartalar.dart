import 'package:bank_card/repository/card.dart';
import 'package:bank_card/repository/home_repository.dart';
import 'package:bank_card/widget/showmodelbottemsheet.dart';
import 'package:bank_card/widget/snekbar.dart';
import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart' hide CardType;

class Kartalar extends StatefulWidget {
  const Kartalar({super.key});

  @override
  State<Kartalar> createState() => KartalarState();
}

class KartalarState extends State<Kartalar> {
  late Future<List<CardModel>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    setState(() {
      _cardsFuture = HomeRepository.getCards();
    });
  }

  void _showDeleteBottomSheet(BuildContext context, CardModel card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1625),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7E22CE).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFF9333EA),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Kartani o'chirish",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Haqiqatan ham ${card.cardnumber} raqamli kartani o'chirib tashlamoqchimisiz?",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        backgroundColor: Colors.white.withOpacity(0.05),
                      ),
                      onPressed: () => Navigator.pop(bottomSheetContext),
                      child: const Text(
                        "Bekor qilish",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7E22CE),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.pop(bottomSheetContext);

                        try {
                          // ⚠️ card.cardnumber emas, bazadagi ID ni berish kerak (masalan: card.id)
                          await HomeRepository.deleteCard(card.documentId.toString());

                          refresh(); // Ro'yxatni yangilash

                          if (context.mounted) {
                            showTopSnackBar(
                              context,
                              "Karta muvaffaqiyatli o'chirildi!",
                              isError: false,
                            );
                          }
                        } catch (e) {
                          print("Xatolik: $e");
                          if (context.mounted) {
                            showTopSnackBar(
                              context,
                              "Xatolik yuz berdi",
                              isError: true,
                            );
                          }
                        }
                      },
                      child: const Text(
                        "O'chirish",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1625),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1625),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Mening kartalarim',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<CardModel>>(
        future: _cardsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF7E22CE)),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Xatolik yuz berdi: ${snap.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            );
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7E22CE).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.credit_card_off_rounded,
                      size: 40,
                      color: Color(0xFF7E22CE),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Kartalar mavjud emas",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final cards = snap.data!;
          return RefreshIndicator(
            color: const Color(0xFF7E22CE),
            backgroundColor: const Color(0xFF1A1625),
            onRefresh: () async => refresh(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () => _showDeleteBottomSheet(context, card),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7E22CE).withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CreditCardUi(
                          creditCardType: CreditCardType.visa,
                          cardHolderFullName: card.holdername,
                          cardNumber: card.cardnumber.toString(),
                          validThru: card.expireData.toString(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7E22CE),
        elevation: 0,
        onPressed: () async {
          final isAdded = await showAddCardBottomSheet(context);
          if (isAdded == true) {
            refresh();
          }
        },
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}
