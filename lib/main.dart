import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qonnect/routes/router.dart';
import 'package:qonnect/services/auth/registration/auth_bloc.dart';
import 'package:toastification/toastification.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthBloc())],
      child: const RootWidget(),
    ),
  );
}

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: RouterHandler().router,
        title: 'Qonnect',
        theme: ThemeData(
          canvasColor: Colors.deepPurple,
          appBarTheme: AppBarTheme(color: Colors.deepPurple),
          primarySwatch: Colors.deepPurple,
        ),
      ),
    );
  }
}
