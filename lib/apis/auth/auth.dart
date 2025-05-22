import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qonnect/utils/handlers/dio_handler.dart';
import 'package:qonnect/utils/handlers/password_hashing.dart';

class AuthApi {
  

  DioHandler dioHandler = DioHandler();

  static String? baseUrl = dotenv.env['CONNECTION_URL'];
  static String get loginUrl => '$baseUrl/api/auth/login';
  static String get registerUrl => '$baseUrl/api/auth/register';

  void _init() {
    if (baseUrl == null) {
      throw Exception('Base URL is not set in .env file');
    }
  }

  Future<Response> login(String email, String password) async {
    _init();
    var hashPasswordString = hashPassword(password);
    try {
      final response = await dioHandler.dio.post(
        loginUrl,
        data: {'email': email, 'hashed_password': hashPasswordString},
      );
      log('Login successful from API: ${response.data}');
      return response;

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
    final response = await dioHandler.dio.post(
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
