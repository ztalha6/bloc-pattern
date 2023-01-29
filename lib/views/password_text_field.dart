import 'package:bloc_pattren_sample/strings.dart' show enterYourEmailHere;
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordTextField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: false,
      obscuringCharacter: '.',
      decoration: const InputDecoration(
        hintText: enterYourEmailHere,
      ),
    );
  }
}
