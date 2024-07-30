import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ProfilePage class to display user's information
class ProfilePage extends StatelessWidget {
  final User user; // User object passed from LoginPage

  ProfilePage({required this.user}); // Constructor to receive the User object

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL ?? ''),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${user.displayName ?? 'No name provided'}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${user.email ?? 'No email provided'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Return to previous screen
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
