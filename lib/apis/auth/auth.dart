import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qonnect/utils/handlers/password_hashing.dart';

class AuthApi {
  Dio dio = Dio();

  static String? baseUrl = dotenv.env['CONNECTION_URL'];
  static String get loginUrl => '$baseUrl/api/auth/login';
  static String get registerUrl => '$baseUrl/api/auth/register';

  void createSecureDio() async {
    final sslCert = await rootBundle.load('rootCA.crt');
    final securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        return HttpClient(context: securityContext)
          ..badCertificateCallback = (cert, host, port) {
            // Optional: Add custom host validation if needed
            return true; // or false to reject
          };
      },
    );
  }

  void _init() {
    createSecureDio();
    if (baseUrl == null) {
      throw Exception('Base URL is not set in .env file');
    }
  }

  Future<void> login(String email, String password) async {
    _init();
    var hashPasswordString = hashPassword(password);
    try {
      final response = await dio.post(
        loginUrl,
        data: {'email': email, 'hashed_password': hashPasswordString},
      );
      log('Login successful from API: ${response.data}');
    } on DioException catch (e) {
    log('Registration failed: ${e.response?.data}');
    throw Exception(e.response?.data ?? e.message);
  } on Exception catch (e) {
    log('Registration failed: $e');
    rethrow;
  }
  }

Future<void> register(
  String email,
  String password,
  String name, {
  String fcmToken = 'abc',
}) async {
  _init();
  var hashPasswordString = hashPassword(password);
  try {
    final response = await dio.post(
      registerUrl,
      data: {
        'email': email,
        'hashed_password': hashPasswordString,
        'name': name,
        'fcm_token': fcmToken,
      },
    );
    log('Registration successful from API: ${response.data}');
  } on DioException catch (e) {
    log('Registration failed: ${e.response?.data}');
    throw Exception(e.response?.data ?? e.message);
  } on Exception catch (e) {
    log('Registration failed: $e');
    rethrow;
  }
}
}
