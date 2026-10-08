import 'dart:convert';
import 'dart:io';

import 'package:bank_card/core/service/aposervice.dart';
import 'package:bank_card/repository/card.dart';

class HomeRepository {
  static Future<List<CardModel>> getCards() async {
    try {
      // 1. URL'ni ApiService.baseUrl orqali hosil qilamiz
      final url = Uri.parse("${ApiService.baseUrl}/cards");

      // 2. ApiService.http orqali interceptor ulangan so'rov yuboramiz
      final response = await ApiService.http.get(url);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);

        // Strapi v4 javobi 'data' massivida keladi
        if (data['data'] != null && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        // 3. Server xabarini xavfsiz o'qiymiz
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? "Noma'lum xatolik yuz berdi";
        throw HttpException(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }
}