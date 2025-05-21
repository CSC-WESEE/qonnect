import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';

class DioHandler {
  Dio dio = Dio();

  DioHandler() {
    createSecureDio();
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
