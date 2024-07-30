import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyClNt-wD3h2hH7-d9Z8VvOy8LUDneJMKXY",
          appId: "1:861621886960:android:331326c53ce6741fb7c735",
          messagingSenderId: "861621886960",
          projectId: "eatit-f68fb"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khane me kya hai',
      // theme: ThemeData(primarySwatch: Colors.orange),
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.black, // Optional: Change button color
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: Colors.black),
      ),
      home: LoginPage(),
    );
  }
}