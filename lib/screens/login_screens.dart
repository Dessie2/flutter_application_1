import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Cerebro de la lógica de las animaciones
  StateMachineController? controller;

  // STATEMACHINE INPUTS
  SMIBool? isCheking; // activa al oso chismoso
  SMIBool? isHandsUp; // activa al oso tapandose los ojos
  SMITrigger? triggerSuccess; // activa al oso feliz
  SMITrigger? triggerFail; // activa al oso triste
  SMINumber? numlook; // mueve los ojos al escribir email

  bool _isPasswordVisible = false;

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
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  // Mantener manos abajo
                  if (isHandsUp != null) isHandsUp!.change(false);

                  // Activar oso chismoso
                  if (isCheking != null) isCheking!.change(true);

                  // Mover ojos del oso según longitud del texto
                  if (numlook != null) {
                    numlook!.value = value.length.toDouble();
                  }
                },
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
                onChanged: (value) {
                  // Desactivar oso chismoso
                  if (isCheking != null) isCheking!.change(false);

                  // Subir manos del oso
                  if (isHandsUp != null) isHandsUp!.change(true);
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

              // OLVIDÓ PASSWORD
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
                  // EJEMPLO: activar éxito o fallo
                  // Aquí puedes agregar validación real de email/password
                  if (triggerSuccess != null) {
                    triggerSuccess!.fire();
                  }
                  // Si quieres usar triggerFail en caso de error:
                  // if (triggerFail != null) triggerFail!.fire();
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
