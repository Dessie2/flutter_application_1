import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Rive controller
  StateMachineController? controller;

  // STATEMACHINE INPUTS
  SMIBool? isCheking;
  SMIBool? isHandsUp;
  SMITrigger? triggerSuccess;
  SMITrigger? triggerFail;
  SMINumber? numlook;

  // TextField focus
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  // Password visibility
  bool _isPasswordVisible = false;

  // Timers
  Timer? _emailIdleTimer;

  @override
  void initState() {
    super.initState();

    // EMAIL focus listener
    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        // Activar oso chismoso esperando que escribas
        if (isCheking != null) isCheking!.change(true);
        if (isHandsUp != null) isHandsUp!.change(false);

        // Iniciar timer de 3 segundos para mirar al frente si no escribe
        _emailIdleTimer?.cancel();
        _emailIdleTimer = Timer(const Duration(seconds: 3), () {
          if (numlook != null) numlook!.value = 0;
          if (isCheking != null) isCheking!.change(false);
        });
      } else {
        // Salir del email: mirar al frente
        _emailIdleTimer?.cancel();
        if (numlook != null) numlook!.value = 0;
        if (isCheking != null) isCheking!.change(false);
      }
    });

    // PASSWORD focus listener
    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        // Taparse los ojos apenas el cursor esté en password
        if (isHandsUp != null) isHandsUp!.change(true);
        if (isCheking != null) isCheking!.change(false);
      } else {
        // Al salir del password, bajar manos
        if (isHandsUp != null) isHandsUp!.change(false);
      }
    });
  }

  void _onEmailChanged(String value) {
    // Cancelar timer de idle al escribir
    _emailIdleTimer?.cancel();

    // Activar oso chismoso mientras escribe
    if (isCheking != null) isCheking!.change(true);
    if (isHandsUp != null) isHandsUp!.change(false);

    // Actualizar posición de ojos en vivo
    if (numlook != null) numlook!.value = value.length.toDouble();

    // Reiniciar timer de 3 segundos para mirar al frente si deja de escribir
    _emailIdleTimer = Timer(const Duration(seconds: 3), () {
      if (numlook != null) numlook!.value = 0;
      if (isCheking != null) isCheking!.change(false);
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailIdleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ANIMACIÓN RIVE
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'animated_login_character.riv',
                  stateMachines: ['Login Machine'],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    if (controller == null) return;
                    artboard.addController(controller!);

                    // Vincular inputs
                    isCheking = controller!.findSMI<SMIBool>("isChecking");
                    isHandsUp = controller!.findSMI<SMIBool>("isHandsUp");
                    triggerSuccess = controller!.findSMI<SMITrigger>(
                      "trigSuccess",
                    );
                    triggerFail = controller!.findSMI<SMITrigger>("trigFail");
                    numlook = controller!.findSMI<SMINumber>("numLook");
                  },
                ),
              ),
              const SizedBox(height: 10),

              // EMAIL
              TextField(
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                onChanged: _onEmailChanged,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // PASSWORD
              TextField(
                focusNode: _passwordFocus,
                onChanged: (value) {
                  // Mientras escribe password, el oso ya está tapándose los ojos
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text(
                  "Forgot your password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),

              // BOTÓN LOGIN
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (triggerSuccess != null) triggerSuccess!.fire();
                },
              ),
              const SizedBox(height: 10),

              // SIGN IN
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
