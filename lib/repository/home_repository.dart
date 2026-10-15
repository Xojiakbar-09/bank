import 'dart:convert';
import 'dart:io';

import 'package:bank_card/core/service/aposervice.dart';
import 'package:bank_card/repository/card.dart';

class HomeRepository {
static Future<List<CardModel>> getCards() async {
  try {
    final url = Uri.parse("${ApiService.baseUrl}/users/me?populate=cards");

    final response = await ApiService.http.get(url);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decodedData = json.decode(response.body);

      final List? cardsList = decodedData['cards'] ?? decodedData['data']?['cards'];

      if (cardsList != null) {
        final allCards = cardsList
            .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
            .toList();

        // --- DUBLIKATLARNI OLIB TASHLASH (ID yoki documentId bo'yicha) ---
        final uniqueCards = <String, CardModel>{};
        for (var card in allCards) {
          // documentId yoki cardnumber bo'yicha unikalligini tekshiramiz
          final key = card.documentId.isNotEmpty ? card.documentId : card.cardnumber.toString();
          uniqueCards[key] = card;
        }

        return uniqueCards.values.toList();
      }
      
      return [];
    } else {
      final errorData = json.decode(response.body);
      final errorMessage =
          errorData['error']?['message'] ?? "Noma'lum xatolik yuz berdi";
      throw HttpException(errorMessage);
    }
  } catch (e) {
    print("Kartalarni olishda xato: $e");
    rethrow;
  }
}

  static Future<void> deleteCard(String cardIdentifier) async {
    final url = Uri.parse('${ApiService.baseUrl}/cards/$cardIdentifier');

    final response = await ApiService.http.delete(url);

    print("Status kodi: ${response.statusCode}");
    print("Server javobi (Body): ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Server xatosi: ${response.body}");
    }
  }
}
