import 'package:doll_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:doll_app/ui/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // This is the theme of your application.
      theme: customThemeData,
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
