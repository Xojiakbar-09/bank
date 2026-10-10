import 'dart:convert';
import 'dart:io';

import 'package:bank_card/core/service/aposervice.dart';
import 'package:bank_card/repository/card.dart';

class HomeRepository {
  static Future<List<CardModel>> getCards() async {
    try {
      final url = Uri.parse("${ApiService.baseUrl}/cards");

      final response = await ApiService.http.get(url);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['error']?['message'] ?? "Noma'lum xatolik yuz berdi";
        throw HttpException(errorMessage);
      }
    } catch (e) {
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
