import 'package:doll_app/ui/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doll_app/ui/screens/user/auth_repository.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository = AuthRepository();
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  Future<void> _signOut() async {
    try {
      await _authRepository.signOutWithAccount();
      // Navigate back to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign out'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    // print(user);
    return CustomScrollView(
      controller: _trackingScrollController,
      slivers: [
        SliverAppBar(
          title: Text('帳號管理'),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Placeholder(
                fallbackHeight: 50,
                fallbackWidth: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('user: ${user?.displayName ?? user?.email}'),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text('登出'),
                  onPressed: _signOut,
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
