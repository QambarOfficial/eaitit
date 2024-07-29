import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildHeader(),
          _buildFamilyList(),
          _buildAddFamilyMemberButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 4, 3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(
                'assets/javier.jpg'), // Replace with your image asset
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Alves Family',
            style: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 237, 235, 235),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Nothing to report - your family are all in a safe digital environment.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 249, 247, 247),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Javier\nAt work',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyList() {
    final familyMembers = [
      FamilyMember('Gustavo', 'Driving', 'assets/gustavo.jpg', true),
      FamilyMember('Elana', 'At home, 2 hrs ago', 'assets/elana.jpg', false),
      FamilyMember('Anna', 'At work, 45 mins ago', 'assets/anna.jpg', false),
      FamilyMember('Rosa', 'Playing Xbox', 'assets/rosa.jpg', true),
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: familyMembers.length,
        itemBuilder: (context, index) {
          final member = familyMembers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(member.imagePath),
            ),
            title: Text(member.name),
            subtitle: Text(member.status),
            trailing: member.requestPending
                ? ElevatedButton(
                    onPressed: () {},
                    child: const Text('Request Pending'),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildAddFamilyMemberButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add a family member'),
      ),
    );
  }
}

class FamilyMember {
  final String name;
  final String status;
  final String imagePath;
  final bool requestPending;

  FamilyMember(this.name, this.status, this.imagePath, this.requestPending);
}



// import 'package:flutter/material.dart';
// import 'package:what_to_eat/admin_dialog.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   List<Map<String, String>> familyMembers = [
//     {"name": "John", "favoriteFood": "Pizza"},
//     {"name": "Emily", "favoriteFood": "Salad"},
//     {"name": "Mike", "favoriteFood": "Burger"},
//   ];

//   Map<String, Map<String, String>> weeklyMenu = {
//     "Monday": {"lunch": "Pizza", "dinner": "Steak"},
//     "Tuesday": {"lunch": "Burger", "dinner": "Fish"},
//     "Wednesday": {"lunch": "Salad", "dinner": "Chicken"},
//     "Thursday": {"lunch": "Pasta", "dinner": "Shrimp"},
//     "Friday": {"lunch": "Sandwich", "dinner": "Rice"},
//     "Saturday": {"lunch": "Soup", "dinner": "Tacos"},
//     "Sunday": {"lunch": "Sushi", "dinner": "Curry"},
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile Screen"),
//       ),
//       body: ListView.builder(
//         itemCount: familyMembers.length,
//         itemBuilder: (context, index) {
//           final member = familyMembers[index];
//           return ListTile(
//             title: Text(member['name'] ?? ''),
//             subtitle: Text('Favorite Food: ${member['favoriteFood'] ?? ''}'),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAdminDialog(context);
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAdminDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AdminDialog(
//           weeklyMenu: weeklyMenu,
//           familyMembers: familyMembers,
//           onMenuUpdate: (String day, String newLunch, String newDinner) {
//             setState(() {
//               weeklyMenu[day]!['lunch'] = newLunch;
//               weeklyMenu[day]!['dinner'] = newDinner;
//             });
//             // Update the weekly menu in your storage or state management as needed
//           },
//           onFamilyUpdate: (List<Map<String, String>> updatedFamilyMembers) {
//             setState(() {
//               familyMembers = updatedFamilyMembers;
//             });
//             // Update the family members in your storage or state management as needed
//           },
//         );
//       },
//     );
//   }
//  }
