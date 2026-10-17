import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.55:1337/api";

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

    // Multipart so'rovlarning o'z Content-Type'i (boundary) buzilib ketmasligi uchun
    // faqat multipart bo'lmagan so'rovlarga application/json o'rnatamiz.
    final contentType = request.headers['Content-Type'] ?? '';
    if (!contentType.toLowerCase().startsWith('multipart/')) {
      request.headers['Content-Type'] = 'application/json';
    }

    return request;
  }

  @override
  FutureOr<bool> shouldInterceptResponse({
    required BaseResponse response,
  }) async {
    return true;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    // 1. Agar 401 xatosi kelsa va bu so'rov allaqachon qayta urinilmagan bo'lsa
    if (response.statusCode == 401 &&
        response.request?.headers['X-Retry'] != 'true') {
      bool refreshed = await _refreshToken();

      if (refreshed) {
        try {
          const secureStorage = FlutterSecureStorage();
          String? newJwt = await secureStorage.read(key: "jwt");

          var request = response.request;
          if (request != null) {
            // 2. So'rov tanasi (body) yo'qolib qolmasligi uchun uni klon qilamiz (nusxalaymiz)
            http.BaseRequest clonedRequest;
            if (request is http.Request) {
              clonedRequest = http.Request(request.method, request.url)
                ..headers.addAll(request.headers)
                ..followRedirects = request.followRedirects
                ..maxRedirects = request.maxRedirects
                ..persistentConnection = request.persistentConnection
                ..bodyBytes = request.bodyBytes;
            } else {
              clonedRequest = request;
            }

            // 3. Yangi JWT tokenni qo'shamiz va qayta urinish bayrog'ini o'rnatamiz
            clonedRequest.headers['Authorization'] = 'Bearer $newJwt';
            clonedRequest.headers['X-Retry'] = 'true';

            // 4. Klondagi so'rovni qayta yuboramiz.
            // MUHIM: http_interceptor natijani `as StreamedResponse` bilan cast qiladi,
            // shuning uchun bu yerda buffered `Response` emas, `StreamedResponse` qaytaramiz.
            return await clonedRequest.send();
          }
        } catch (e) {
          debugPrint("So'rovni qayta yuborishda xatolik: $e");
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
        Uri.parse("${ApiService.baseUrl}/token/refresh"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);
        final newJwt = data["jwt"];

        // Javobda jwt bo'lmasa, mavjud tokenni o'chirib yubormaymiz
        if (newJwt is String && newJwt.isNotEmpty) {
          await secureStorage.write(key: "jwt", value: newJwt);
          if (data["refreshToken"] is String) {
            await secureStorage.write(
              key: "refresh_token",
              value: data["refreshToken"],
            );
          }
          return true;
        }
        debugPrint("Tokenni yangilashda javobda jwt topilmadi");
      }
    } catch (e) {
      debugPrint("Tokenni yangilashda xato: $e");
    }

    await secureStorage.deleteAll();
    return false;
  }
}
