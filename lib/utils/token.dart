import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> saveTokenToPrefs() async {
  User? user = FirebaseAuth.instance.currentUser;
  String token = user!.uid;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userToken', token);
}

Future<String?> getTokenFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userToken');
}
