import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/people/v1.dart' as people_api;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'SignInScreen.dart';
import 'user_prefs.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
  );

  late Future<List<Map<String, dynamic>>> _contactsFuture;
  List<Map<String, dynamic>> _familyMembers = []; // List to store family members

  @override
  void initState() {
    super.initState();
    _contactsFuture = _fetchContacts();
  }

  Future<List<Map<String, dynamic>>> _fetchContacts() async {
    try {
      GoogleSignInAccount? googleUser = _googleSignIn.currentUser;

      if (googleUser == null) {
        googleUser = await _googleSignIn.signInSilently();
        if (googleUser == null) {
          googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            throw Exception('User did not sign in with Google.');
          }
        }
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        throw Exception('Google access token is missing.');
      }

      final authClient = auth.authenticatedClient(
        http.Client(),
        auth.AccessCredentials(
          auth.AccessToken(
            'Bearer',
            accessToken,
            DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
          null,
          ['https://www.googleapis.com/auth/contacts.readonly'],
        ),
      );

      final peopleApi = people_api.PeopleServiceApi(authClient);
      final response = await peopleApi.people.connections.list(
        'people/me',
        personFields: 'names,emailAddresses,photos,phoneNumbers',
      );

      final contacts = response.connections ?? [];
      return contacts.map((contact) {
        final name = contact.names?.isNotEmpty == true ? contact.names!.first.displayName : 'No Name';
        final email = contact.emailAddresses?.isNotEmpty == true ? contact.emailAddresses!.first.value : 'No Email';
        final photoUrl = contact.photos?.isNotEmpty == true ? contact.photos!.first.url : '';
        final phoneNumber = contact.phoneNumbers?.isNotEmpty == true ? contact.phoneNumbers!.first.value : 'No Phone Number';

        return {
          'name': name,
          'email': email,
          'photoUrl': photoUrl,
          'phoneNumber': phoneNumber,
        };
      }).toList();
    } catch (e) {
      print('Error fetching contacts: $e');
      return [];
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();
      print('Google sign-out successful');
      
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      print('Firebase sign-out successful');
      
      // Clear saved user data
      await UserPrefs.clearUser();
      print('UserPrefs cleared');
      
      // Navigate to the SignInScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      print('Error signing out: $e');
      // Optionally display an error message to the user
    }
  }

  void _signOut(BuildContext context) {
    // Call the async method but handle it within the void function
    _handleSignOut(context);
  }

  void _addFamilyMember(Map<String, dynamic> contact) {
    setState(() {
      _familyMembers.add(contact);
    });
  }

  void _removeFamilyMember(Map<String, dynamic> contact) {
    setState(() {
      _familyMembers.remove(contact);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refetch contacts if needed when dependencies change
    _contactsFuture = _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Use Scaffold.of to open the end drawer
              },
            ),
          ),
        ],
      ),

      endDrawer: Drawer( // Changed from 'drawer' to 'endDrawer'
        child: Column(
          children: [
            AppBar(
              title: const Text('Contacts'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _signOut(context), // Logout option in the drawer
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _contactsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No contacts found.'));
                  }

                  final contacts = snapshot.data!;

                  return ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: contact['photoUrl'] != ''
                              ? NetworkImage(contact['photoUrl'])
                              : null,
                          child: contact['photoUrl'] == ''
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(contact['name'] ?? 'No Name'),
                        subtitle: Text(contact['email'] ?? 'No Email'),
                        trailing: Text(contact['phoneNumber'] ?? 'No Phone Number'),
                        onTap: () {
                          _addFamilyMember(contact); // Add contact to family members
                          Navigator.pop(context); // Close the drawer
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.photoURL ?? ''),
                radius: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'Name: ${widget.user.displayName ?? 'No Name'}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Email: ${widget.user.email ?? 'No Email'}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              const Text(
                'Family Members:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _familyMembers.length,
                  itemBuilder: (context, index) {
                    final contact = _familyMembers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: contact['photoUrl'] != ''
                            ? NetworkImage(contact['photoUrl'])
                            : null,
                        child: contact['photoUrl'] == ''
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(contact['name'] ?? 'No Name'),
                      subtitle: Text(contact['email'] ?? 'No Email'),
                      trailing: Text(contact['phoneNumber'] ?? 'No Phone Number'),
                      onLongPress: () => _removeFamilyMember(contact), // Long press to remove
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open the end drawer
                },
                child: const Text('Add Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
