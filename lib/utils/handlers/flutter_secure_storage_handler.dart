import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageHandler {
late  FlutterSecureStorage secureStorage;

  FlutterSecureStorageHandler() {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    secureStorage = FlutterSecureStorage(aOptions: getAndroidOptions(), lOptions: LinuxOptions.defaultOptions);
  }
}
