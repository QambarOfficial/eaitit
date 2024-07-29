import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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
      body: const Center(
        child: Text(
          'Search Screen Content',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
