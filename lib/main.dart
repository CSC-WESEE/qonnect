import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qonnect/routes/router.dart';
import 'package:qonnect/routes/routes.dart';
import 'package:qonnect/service_locators/locators.dart';
import 'package:qonnect/services/address_book/address_bloc.dart';
import 'package:qonnect/services/auth/authentication_repository.dart';
import 'package:qonnect/services/auth/registration/auth_bloc.dart';
import 'package:qonnect/services/socket_connection/socket_service.dart';
import 'package:qonnect/utils/handlers/dio_handler.dart';
import 'package:toastification/toastification.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => getIt<AuthenticationRepository>()),
        RepositoryProvider(create: (context) => getIt<RouterHandler>()),
        RepositoryProvider(create: (context) => getIt<DioHandler>(),),
        RepositoryProvider(create: (context) => getIt<SocketService>(),)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => AddressBloc()),
        ],
        child: const RootWidget(),
      ),
    ),
  );
}

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  late final AuthenticationRepository _authRepository;
  late final RouterHandler _routerHandler;

  @override
  void initState() {
    super.initState();
    _authRepository = context.read<AuthenticationRepository>();
    _routerHandler = context.read<RouterHandler>();
    _authRepository.status.listen((status) {
      log(status.toString(), name: "Status");
      if (status == AuthenticationStatus.authenticated) {
        _routerHandler.router.go(Routes.dashboard);
      } else {
        _routerHandler.router.go(Routes.loginPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _routerHandler.router, // Use the same instance
        title: 'Qonnect',
        theme: ThemeData(
          canvasColor: Colors.deepPurple,
          appBarTheme: const AppBarTheme(color: Colors.deepPurple),
          primarySwatch: Colors.deepPurple,
        ),
      ),
    );
  }
}
