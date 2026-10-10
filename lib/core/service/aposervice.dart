import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.224:1337/api";

  // RetryPolicy bo'sh ro'yxat qilindi yoki olib tashlandi, chunki 401 da token refresh mantiqi yo'q
  static final http = InterceptedClient.build(
    interceptors: [TokenInterceptor()],
  );
}

class TokenInterceptor implements HttpInterceptor {
  final _secureStorage = const FlutterSecureStorage();

  @override
  FutureOr<bool> shouldInterceptRequest({required BaseRequest request}) {
    return true;
  }

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String? jwt = await _secureStorage.read(key: "jwt");

    if (jwt != null) {
      request.headers['Authorization'] = 'Bearer $jwt';
    }
    request.headers['Content-Type'] = 'application/json';

    return request;
  }

  @override
  FutureOr<bool> shouldInterceptResponse({required BaseResponse response}) {
    return true;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (response.statusCode == 401 || response.statusCode == 403) {
      await _secureStorage.deleteAll();
    }
    return response;
  }
}