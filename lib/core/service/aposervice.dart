import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.233:1337/api";

  static final http = InterceptedClient.build(
    interceptors: [const TokenInterceptor()],
  );
}

class TokenInterceptor implements HttpInterceptor {
  const TokenInterceptor();

  @override
  FutureOr<bool> shouldInterceptRequest({required BaseRequest request}) async {
    return true;
  }

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) async {
    const secureStorage = FlutterSecureStorage();
    String? jwt = await secureStorage.read(key: "jwt");

    if (jwt != null) {
      request.headers['Authorization'] = 'Bearer $jwt';
    }
    request.headers['Content-Type'] = 'application/json';

    return request;
  }

  @override
  FutureOr<bool> shouldInterceptResponse({required BaseResponse response}) async {
    return true;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) async {
    // Agar token eskirgan bo'lsa (401 Unauthorized)
    if (response.statusCode == 401) {
      bool refreshed = await _refreshToken();
      
      if (refreshed) {
        try {
          const secureStorage = FlutterSecureStorage();
          String? newJwt = await secureStorage.read(key: "jwt");

          var request = response.request;
          if (request != null) {
            request.headers['Authorization'] = 'Bearer $newJwt';
            final streamedResponse = await request.send();
            return await Response.fromStream(streamedResponse);
          }
        } catch (e) {
          print("So'rovni qayta yuborishda xatolik: $e");
        }
      }
    }
    return response;
  }

  Future<bool> _refreshToken() async {
    const secureStorage = FlutterSecureStorage();
    final refreshToken = await secureStorage.read(key: "refresh_token");

    if (refreshToken == null) {
      await secureStorage.deleteAll();
      return false;
    }

    try {
      final res = await http.post(
        Uri.parse("http://192.168.100.8:1337/api/token/refresh"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);
        final newJwt = data["jwt"];

        await secureStorage.write(key: "jwt", value: newJwt);
        if (data["refreshToken"] != null) {
          await secureStorage.write(key: "refresh_token", value: data["refreshToken"]);
        }
        return true;
      }
    } catch (e) {
      print("Tokenni yangilashda xato: $e");
    }

    await secureStorage.deleteAll();
    return false;
  }
}