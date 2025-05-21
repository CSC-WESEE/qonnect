import 'package:go_router/go_router.dart';
import 'package:qonnect/routes/routes.dart';
import 'package:qonnect/screens/authentication/login_page.dart';
import 'package:qonnect/screens/dashboard/dashboard.dart';
import 'package:qonnect/screens/dashboard/home/home_page.dart';
import 'package:qonnect/utils/handlers/flutter_secure_storage_handler.dart';

class RouterHandler {
  FlutterSecureStorageHandler flutterSecureStorageHandler =
      FlutterSecureStorageHandler();

  Future<bool> isLoggedIn() async {
    var token = await flutterSecureStorageHandler.secureStorage!.read(
      key: 'token',
    );
    return token != null && token.isNotEmpty;
  }

  final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isAuthenticated = await FlutterSecureStorageHandler().secureStorage!
          .read(key: 'token');

      final isLoggingIn = state.path == Routes.loginPage;

      if (isAuthenticated == null && !isLoggingIn) {
        return Routes.loginPage;
      }
      if (isAuthenticated != null && isLoggingIn) {
        return Routes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => Routes.dashboard),
      GoRoute(
        path: Routes.homePage,
        name: Routes.homePage,
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => const Dashboard(),
      ),
      GoRoute(path: Routes.loginPage, builder: (context, state) => LoginPage()),
    ],
  );
}
