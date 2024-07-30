import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

import 'chat_screen.dart';
import 'profilePage.dart';
import 'search_screen.dart';
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar if needed
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! < 0) {
            // Swiped left
            if (_selectedIndex < _widgetOptions.length - 1) {
              setState(() {
                _selectedIndex++;
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              });
            }
          } else if (details.primaryVelocity! > 0) {
            // Swiped right
            if (_selectedIndex > 0) {
              setState(() {
                _selectedIndex--;
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              });
            }
          }
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _widgetOptions,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  static List<Widget> _widgetOptions = <Widget>[
    const ChatScreen(),
    const SearchScreen(),
    ProfilePage(),
  ];
}
