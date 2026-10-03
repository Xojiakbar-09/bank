import 'dart:convert';
import 'dart:io';

import 'package:bank_card/repository/card.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  static Future<List<CardModel>> getcard() async {
    try {
      final url = Uri.parse(
        "${Platform.isAndroid ? "http://192.168.1.152:1337/" : "http://localhost:1337/"}api/cards",
      );
      final respons = await http.get(url);

      if (respons.statusCode >= 200 && respons.statusCode < 300) {
        final data = json.decode(respons.body);
        return (data['data'] as List)
            .map((e) => CardModel.fromJson(e))
            .toList();
      } else {
        throw HttpException(json.decode(respons.body)['error']['message']);
      }
    } catch (e) {
      rethrow;
      
    }
  }
}
