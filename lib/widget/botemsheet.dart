import 'package:bank_card/core/service/aposervice.dart';
import 'package:bank_card/repository/card.dart';
import 'package:bank_card/widget/snekbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool?> showDeleteCardBottomSheet(BuildContext context, CardModel card) {
  return showModalBottomSheet<bool>(
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
                    onPressed: () => Navigator.pop(bottomSheetContext, false),
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
                      // 1. Dialogni yopishdan oldin token va ID ni olib olamiz
                      const storage = FlutterSecureStorage();
                      final jwtToken = await storage.read(key: 'jwt');

                      Navigator.pop(bottomSheetContext, true);

                      try {
                        final cardId = card.documentId.isNotEmpty 
                            ? card.documentId 
                            : card.cardnumber.toString();
                        
                        final deleteUrl = Uri.parse("${ApiService.baseUrl}/cards/$cardId");
                        
                        // 2. Tokenni to'g'ridan-to'g'ri header'ga qo'shamiz
                        final response = await ApiService.http.delete(
                          deleteUrl,
                          headers: {
                            if (jwtToken != null) 'Authorization': 'Bearer $jwtToken',
                            'Content-Type': 'application/json',
                          },
                        );

                        if (response.statusCode >= 200 && response.statusCode < 300) {
                          if (context.mounted) {
                            showTopSnackBar(
                              context,
                              "Karta muvaffaqiyatli o'chirildi!",
                              isError: false,
                            );
                          }
                        } else {
                          print("Server xatosi (${response.statusCode}): ${response.body}");
                          throw Exception("Server xatosi: ${response.statusCode}");
                        }
                      } catch (e) {
                        print("O'chirishda xatolik: $e");
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