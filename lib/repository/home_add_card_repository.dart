import 'dart:convert';
import 'package:bank_card/core/service/aposervice.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeAddCardRepository {
  static Future<void> creatNewCard({
    required String name,
    required String cardNumber,
    required int cvv,
    required DateTime mudatti,
  }) async {
    try {
      final storage = FlutterSecureStorage();
      
      final String? jwtToken = await storage.read(key: 'jwt');
      if (jwtToken == null) {
        throw Exception("Token topilmadi, iltimos qaytadan kiring");
      }

      final userID = await storage.read(key: 'userId');
      final userId = int.parse(userID ?? "0");
      
      final url = Uri.parse("${ApiService.baseUrl}/cards");

      final formattedDate =
          "${mudatti.year}-${mudatti.month.toString().padLeft(2, '0')}-${mudatti.day.toString().padLeft(2, '0')}";

      // 3. So'rovga Authorization header'ni qo'shamiz
      final response = await ApiService.http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwtToken", 
        },
        body: jsonEncode({
          "data": {
            "name": name,
            "number": int.parse(cardNumber), 
            "mudatti": formattedDate,         
            "cvv": cvv,
            "user": userId              
          }
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Muvaffaqiyatli saqlandi: ${response.body}");
      } else {
        print("Server xatosi (${response.statusCode}): ${response.body}");
        throw Exception("Server xatosi: ${response.statusCode}");
      }
    } catch (e) {
      print('Repository error: $e');
      rethrow;
    }
  }
}