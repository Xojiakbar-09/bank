import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bank_card/core/utils/anicolors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  static Future<void> registor({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final url = Uri.parse(
        "http://192.168.1.224:1337/api/auth/local/register",
      );

      final respons = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        }, // <-- Shu qatorni qo'shing
        body: jsonEncode({
          // <-- jsonEncode qiling
          "email": email,
          "password": password,
          "username": username,
        }),
      );

      final data = jsonDecode(respons.body);

      if (respons.statusCode >= 200 && respons.statusCode < 300) {
        final token = data["jwt"];
        print("Saqlanayotgan JWT: $token");
        print("TEKshiruv - Token qiymati: $token");

        // Tokenni SecureStorage ga yozish
        const secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: "jwt", value: token);

        // Agar refresh token mavjud bo'lsagina yozamiz
        if (data["refreshToken"] != null) {
          await secureStorage.write(
            key: "refresh_token",
            value: data["refreshToken"],
          );
        }

        AnsiColor.success('yaxshi');
      } else {
        final errorMessage =
            data["error"]?["message"] ?? data["message"] ?? "Noma'lum xatolik";
        throw HttpException(errorMessage);
      }
    } on SocketException catch (_) {
      throw SocketException('Internetingizni tekshiring');
    } on TimeoutException catch (_) {
      throw TimeoutException('Keyinroq urinib ko\'ring');
    } catch (error) {
      print("Xatolik tafsiloti: $error");
      rethrow;
    }
  }

  static Future<void> login({
    required String identifier, // Email yoki Username
    required String password,
  }) async {
    try {
      final url = Uri.parse(
        "http://192.168.1.224:1337/api/auth/local",
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "identifier": identifier,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = data["jwt"];
        
        const secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: "jwt", value: token);
        
        if (data["refreshToken"] != null) {
          await secureStorage.write(key: "refresh_token", value: data["refreshToken"]);
        }
      } else {
        final errorMessage =
            data["error"]?["message"] ?? data["message"] ?? "Kirishda xatolik yuz berdi";
        throw HttpException(errorMessage);
      }
    } catch (error) {
      rethrow;
    }
  }

}
