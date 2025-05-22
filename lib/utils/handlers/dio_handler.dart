import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qonnect/utils/handlers/flutter_secure_storage_handler.dart';

class DioHandler {
  static String token = '';
  late Dio dio;

  Future<void> getJwtToken() async {
    var fetchedToken = await FlutterSecureStorageHandler().secureStorage.read(
      key: 'token',
    );
    token = fetchedToken ?? '';
  }

  Future<void> initialize() async {
    await getJwtToken();
    dio = Dio()
      ..options.baseUrl = '${dotenv.env['CONNECTION_URL']}'
      ..options.headers['Authorization'] = 'Bearer $token';
    await createSecureDio();
  }

  DioHandler() {
    initialize();
  }

  Future<void> createSecureDio() async {
    final sslCert = await rootBundle.load('rootCA.crt');
    final securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        return HttpClient(context: securityContext)
          ..badCertificateCallback = (cert, host, port) => true;
      },
    );
  }
}
