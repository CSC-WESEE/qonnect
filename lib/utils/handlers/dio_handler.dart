import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qonnect/utils/handlers/flutter_secure_storage_handler.dart';

class DioHandler {
  static String token = '';

  Future<String> getJwtToken() async {
    var token = await FlutterSecureStorageHandler().secureStorage?.read(
      key: 'token',
    );
    return token!;
  }

  Dio dio =
      Dio()
        ..options.baseUrl = '${dotenv.env['CONNECTION_URL']}'
        ..options.headers['Content-Type'] = 'application/json'
        ..options.headers['Authorization'] = 'Bearer $token';

  DioHandler() {
    createSecureDio();
    getJwtToken().then((value) {
      token = value;
    });
  }

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
}
