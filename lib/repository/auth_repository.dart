import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bank_card/core/utils/anicolors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  static const String baseUrl = "http://192.168.1.86:1337";

  static Future<void> registor({
    required String email,
    required String password,
    required String username,
    File? imageFile,
  }) async {
    const secureStorage = FlutterSecureStorage();

    try {
      final regUrl = Uri.parse("$baseUrl/api/auth/local/register");
      final response = await http.post(
        regUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final errorMessage =
            data["error"]?["message"] ?? "Ro'yxatdan o'tishda xatolik";
        print(errorMessage);
        throw HttpException(errorMessage);
      }

      final String jwtToken = data["jwt"];
      final int userId = data["user"]["id"];

      // Tokenlarni saqlaymiz
      await secureStorage.write(key: "jwt", value: jwtToken);
      if (data["refreshToken"] != null) {
        await secureStorage.write(
          key: "refresh_token",
          value: data["refreshToken"],
        );
      }

      // Rasm mavjud bo'lsa Strapi'ga yuboramiz
      if (imageFile != null) {
        final uploadUrl = Uri.parse("$baseUrl/api/upload");
        var uploadRequest = http.MultipartRequest('POST', uploadUrl);

        uploadRequest.headers['Authorization'] = 'Bearer $jwtToken';
        uploadRequest.fields['ref'] = 'plugin::users-permissions.user';
        uploadRequest.fields['refId'] = userId.toString();
        uploadRequest.fields['field'] = 'avatar';

        var multipartFile = await http.MultipartFile.fromPath(
          'files',
          imageFile.path,
        );
        uploadRequest.files.add(multipartFile);

        var streamedResponse = await uploadRequest.send();
        var uploadResponse = await http.Response.fromStream(streamedResponse);

        if (uploadResponse.statusCode < 200 ||
            uploadResponse.statusCode >= 300) {
          print("Rasm yuklashda xatolik tafsiloti: ${uploadResponse.body}");
          throw HttpException("Rasm yuklashda xatolik: ${uploadResponse.body}");
        }
      }

      AnsiColor.success('Muvaffaqiyatli ro\'yxatdan o\'tildi');
    } on SocketException catch (_) {
      throw const SocketException('Internetingizni tekshiring');
    } on TimeoutException catch (_) {
      throw TimeoutException('Kutish vaqti tugadi, keyinroq urinib ko\'ring');
    } catch (error) {
      print("Ro'yxatdan o'tish xatosi: $error");
      rethrow;
    }
  }

  static Future<void> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/api/auth/local");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"identifier": identifier, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = data["jwt"];

        const secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: "jwt", value: token);

        if (data["refreshToken"] != null) {
          await secureStorage.write(
            key: "refresh_token",
            value: data["refreshToken"],
          );
        }
        AnsiColor.success('Muvaffaqiyatli kirildi');
      } else {
        final errorMessage =
            data["error"]?["message"] ??
            data["message"] ??
            "Login yoki parol xato";
        throw HttpException(errorMessage);
      }
    } catch (error) {
      print("Login xatolik tafsiloti: $error");
      rethrow;
    }
  }
}