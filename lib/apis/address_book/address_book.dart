import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:qonnect/service_locators/locators.dart';
import 'package:qonnect/utils/handlers/dio_handler.dart';

class AddressBookApi {
  final dioHandler = getIt<DioHandler>();

  Future<Response> getAddressBookUsers() async {
    try {
      await dioHandler.initialize(); 
      final response = await dioHandler.dio.get('/api/users');
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
