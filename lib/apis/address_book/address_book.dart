import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qonnect/utils/handlers/dio_handler.dart';

class AddressBookApi {
  DioHandler dioHandler = DioHandler();

  static String? baseUrl = dotenv.env['CONNECTION_URL'];

  static String get addressBookFetchUrl => '$baseUrl/api/users';

  Future<Response> getAddressBookUsers() async {
    try {
      final response = await dioHandler.dio.get(addressBookFetchUrl);
      log(response.data.toString());
      return response;
    } on DioException catch (e) {
      log(e.toString());
      throw Exception(e.response?.data);
    } on Exception catch (e) {
      log('Registration failed: $e');
      rethrow;
    }
  }
}
