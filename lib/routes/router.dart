import 'package:go_router/go_router.dart';
import 'package:qonnect/routes/routes.dart';
import 'package:qonnect/screens/authentication/login_page.dart';
import 'package:qonnect/screens/dashboard/dashboard.dart';
import 'package:qonnect/screens/dashboard/home/home_page.dart';
import 'package:qonnect/utils/handlers/flutter_secure_storage_handler.dart';

class RouterHandler {
 

  final GoRouter router = GoRouter(
    initialLocation: Routes.loginPage,
     redirect: (context, state) async {
      final isAuthenticated = await FlutterSecureStorageHandler()
          .secureStorage!
          .read(key: 'token');
      
      final isLoggingIn = state.path == Routes.loginPage;

      // If not logged in and not on login page, redirect to login
      if (isAuthenticated == null && !isLoggingIn) {
        return Routes.loginPage;
      }

      // If logged in and on login page, redirect to dashboard
      if (isAuthenticated != null && isLoggingIn) {
        return Routes.dashboard;
      }

      return null;
    },
    routes: [
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
      GoRoute(
        path: Routes.loginPage, 
        builder: (context, state) => LoginPage()
      ),
    ],
  );
}