import 'dart:async';
import 'package:qonnect/utils/handlers/flutter_secure_storage_handler.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationRepository {
  FlutterSecureStorageHandler flutterSecureStorageHandler = FlutterSecureStorageHandler();
  final _controller = StreamController<AuthenticationStatus>.broadcast();

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  void checkIfAuthenticated() async {
    final token = await FlutterSecureStorageHandler().secureStorage!.read(
      key: 'token',
    );
    if (token == null || token.isEmpty) {
      _controller.add(AuthenticationStatus.unauthenticated);
    } else {
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
