import 'package:flutter/material.dart';
import 'package:qonnect/routes/router.dart';

void main() {
  runApp(const RootWidget());
}


class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Qonnect',
      theme: ThemeData(
        canvasColor: Colors.deepPurple,
        appBarTheme: AppBarTheme(color: Colors.deepPurple),
        primarySwatch: Colors.deepPurple,
      ),
      
    );
  }
}

