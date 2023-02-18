import 'package:doll_app/ui/screens/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doll_app/ui/screens/login_screen.dart';

import '../../utils/token.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
  }

  // 檢查狀態是否已登入
  Future<void> checkAuthenticationStatus() async {
    try {
      String? token = await getTokenFromPrefs();
      if (token != null) {
        setState(() {
          isAuthenticated = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveTokenToPrefs() async {
    User? user = FirebaseAuth.instance.currentUser;
    String token = user!.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isAuthenticated ? NavScreen() : LoginScreen(),
    );
  }
}