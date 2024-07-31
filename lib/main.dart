// main.dart
import 'package:eatit/HomeNavigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SignInScreen.dart';
import 'ProfileScreen.dart';
// import 'user_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyClNt-wD3h2hH7-d9Z8VvOy8LUDneJMKXY",
      appId: "1:861621886960:android:331326c53ce6741fb7c735",
      messagingSenderId: "861621886960",
      projectId: "eatit-f68fb",
    ),
  );

  final firebaseUser = FirebaseAuth.instance.currentUser;
  
  runApp(MyApp(user: firebaseUser));
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khane me kya hai',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.black,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: Colors.black),
      ),
      home: user == null ? SignInScreen() : HomeNavigationBar(user: user!),
    );
  }
}
