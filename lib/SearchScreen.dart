import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for User type

class SearchScreen extends StatefulWidget {
  final User user; // Add this line to accept User parameter

  const SearchScreen({super.key, required this.user}); // Modify constructor

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Variable to hold current date
  late String _currentDate;

  @override
  void initState() {
    super.initState();
    // Initialize current date when the widget is initialized
    _currentDate = _getFormattedDate();
  }

  // Method to get current date in a formatted string
  String _getFormattedDate() {
    return DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _currentDate,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Search Screen Content',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'User: ${widget.user.displayName ?? 'No Name'}', // Display user name or default text
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
