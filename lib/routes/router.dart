import 'package:go_router/go_router.dart';
import 'package:qonnect/routes/routes.dart';
import 'package:qonnect/screens/authentication/login_page.dart';
import 'package:qonnect/screens/dashboard/dashboard.dart';
import 'package:qonnect/screens/dashboard/home/home_page.dart';
import 'package:qonnect/screens/dashboard/messaging/users.dart';

class RouterHandler {
  final GoRouter router = GoRouter(
    initialLocation: Routes.loginPage,
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
      GoRoute(path: Routes.loginPage, builder: (context, state) => LoginPage()),
      GoRoute(path: Routes.users, builder: (context, state) => UserListPage()),
    ],
  );
}
