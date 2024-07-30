import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/people/v1.dart' as people;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;

// Your OAuth2 credentials (replace with your own)
const _clientId = '861621886960-n9fb3a6elhj48acjh298cu3956b052ng.apps.googleusercontent.com';
const _clientSecret = 'YOUR_CLIENT_SECRET';
const _scopes = [people.PeopleServiceApi.contactsReadonlyScope];

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late http.Client _client;
  late AuthClient _authClient;
  List<people.Person>? _contacts;

  @override
  void initState() {
    super.initState();
    _initializeClient();
  }

  Future<void> _initializeClient() async {
    final clientId = ClientId(_clientId, _clientSecret);
    final authClient = await clientViaUserConsent(clientId, _scopes, (url) {
      // Display URL for user consent
      print('Please go to the following URL and grant access: $url');
    });

    setState(() {
      _authClient = authClient;
      _client = http.Client();
    });

    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    final peopleApi = people.PeopleServiceApi(_authClient);
    final response = await peopleApi.people.connections.list(
      'people/me',
      personFields: 'names,emailAddresses',
    );

    setState(() {
      _contacts = response.connections;
    });
  }

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
              backgroundImage: NetworkImage(widget.user.photoURL ?? ''),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${widget.user.displayName ?? 'No name provided'}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${widget.user.email ?? 'No email provided'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Sign Out'),
            ),
            const SizedBox(height: 20),
            if (_contacts == null)
              const CircularProgressIndicator()
            else if (_contacts!.isEmpty)
              const Text('No contacts found.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _contacts!.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts![index];
                    final name = contact.names?.first.displayName ?? 'No name';
                    final email = contact.emailAddresses?.first.value ?? 'No email';
                    return ListTile(
                      title: Text(name),
                      subtitle: Text(email),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }
}
