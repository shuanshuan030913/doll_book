import 'package:flutter/material.dart';
import 'package:doll_app/ui/user/auth_repository.dart';
import 'package:doll_app/ui/screens/nav_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthRepository _authRepository = AuthRepository();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: TextButton(
            onPressed: () async {
              final ok = await _authRepository.signInWithGoogle();
              if (ok) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavScreen(),
                  ),
                );
              }
            },
            child: Text("登入"),
          ),
        ),
      ),
    );
  }
}