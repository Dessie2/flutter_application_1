import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo jiji',
      debugShowCheckedModeBanner: false, //quita la banderita "debug" de la app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(title: '',),
    );
  }
}