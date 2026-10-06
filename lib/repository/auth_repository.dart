import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bank_card/core/utils/anicolors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  static Future<void> registor({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final url = Uri.parse(
        "http://192.168.1.163:1337/api/auth/local/register",
      );

      final respons = await http.post(
        url,
        body: {"email": email, "password": password, "username": username},
      );

      final data = jsonDecode(respons.body);

      if (respons.statusCode >= 200 && respons.statusCode <= 300) {
        // Tokenni GetStorage ga saqlash ('jwt' yoki 'token' ekanligini API'ga qarab tekshiring)
        final box = GetStorage();
        box.write('token', data['jwt']);

        AnsiColor.success('yaxshi');
      } else {
        // Server qaytargan aniq xabar yoki standart xatolik
        final errorMessage = data["error"]?["message"] ?? data["message"] ?? "Noma'lum xatolik";
        throw HttpException(errorMessage);
      }
    } on SocketException catch (_) {
      throw const SocketException('Internetingizni tekshiring');
    } on TimeoutException catch (_) {
      throw TimeoutException('Keyinroq urinib ko\'ring');
    } catch (error) {
      print("Xatolik tafsiloti: $error");
      rethrow;
    }
  }
}