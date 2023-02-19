
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepositoryImpl {
  Future<bool> signInWithGoogle();
  Future<void> signOutWithAccount();
}

class AuthRepository implements AuthRepositoryImpl {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  @override
  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return false;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
    final User? user = authResult.user;

    // Save user token to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user != null) {
      prefs.setString('userToken', user.uid);
    }

    return true;
  }

  @override
  Future<void> signOutWithAccount() async {

    // Sign out of Firebase and Google
    Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);

    // Delete user token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }
}