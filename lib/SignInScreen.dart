// SignInScreen.dart
import 'HomeNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_prefs.dart';

class SignInScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  SignInScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Save user details using UserPrefs
          await UserPrefs.saveUser(
            user.uid,
            user.email ?? '',
            user.displayName ?? '',
            user.photoURL ?? '',
          );

          // Navigate to HomeNavigationBar with the authenticated user
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeNavigationBar(user: user)),
          );
        } else {
          // Handle the case where the user is null
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not found')),
          );
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signInWithGoogle(context),
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
