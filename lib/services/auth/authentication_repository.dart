import 'dart:async';
import 'dart:developer';
import 'package:qonnect/utils/handlers/flutter_secure_storage_handler.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationRepository {
  FlutterSecureStorageHandler flutterSecureStorageHandler = FlutterSecureStorageHandler();
  late String? token;
  final _controller = StreamController<AuthenticationStatus>.broadcast();

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  Future<void> checkIfAuthenticated() async {
     token = await FlutterSecureStorageHandler().secureStorage.read(
      key: 'token',
    );
    if (token == null || token!.isEmpty) {
      log(token.toString(), name: "Token from service 1" );
      _controller.add(AuthenticationStatus.unauthenticated);
    } else {
      log(token.toString(), name: "Token from service");
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  void dispose() {
    _controller.close();
  }

  AuthenticationRepository() {
    checkIfAuthenticated();
  }
}
