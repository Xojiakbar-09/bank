import 'dart:convert';
import 'package:bank_card/core/service/aposervice.dart';

class HomeAddCardRepository {
  static Future<void> creatNewCard({
    required String name,
    required String cardNumber,
    required int cvv,
    required DateTime mudatti,
  }) async {
    try {
      final url = Uri.parse("${ApiService.baseUrl}/cards");

    
      final formattedDate =
          "${mudatti.year}-${mudatti.month.toString().padLeft(2, '0')}-${mudatti.day.toString().padLeft(2, '0')}";

      final response = await ApiService.http.post(
        url,
        body: jsonEncode({
          "data": {
            "name": name,
            "number": int.parse(cardNumber), 
            "mudatti": formattedDate,        
            "cvv": cvv,                      
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