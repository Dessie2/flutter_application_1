import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key, required String title});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: RiveAnimation.asset('animated_login_character.riv')),
          ],
        ),
      ),
    );
  }
}
