import 'package:book_finder/providers/theme_provider.dart';
import 'package:book_finder/screens/auth/signup_screen.dart';
import 'package:book_finder/services/firebase_name_saving.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false; // to toggle TextField
  final TextEditingController nameController = TextEditingController();
  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final data = await FirebaseNameSaving().getName();
    setState(() {
      userName = data?['userName'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ Profile Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('images/my.jpeg'),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Username with edit button
                  Row(
                    children: [
                      isEditing
                          ? Padding(
                              padding: const EdgeInsets.only(left: 140),
                              child: SizedBox(
                                width: 120,
                                child: TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter Name",

                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 140),
                              child: Text(
                                userName.isNotEmpty ? userName : "User",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: Icon(
                          isEditing ? Icons.check : Icons.edit,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () async {
                          if (isEditing) {
                            // Save the name
                            String newName = nameController.text.trim();
                            if (newName.isNotEmpty) {
                              await FirebaseNameSaving().saveName(newName);
                              setState(() {
                                userName = newName;
                                isEditing = false;
                              });
                            }
                          } else {
                            // Start editing
                            nameController.text = userName;
                            setState(() {
                              isEditing = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Email
                  Text(
                    user?.email ?? "No Email",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ✅ Settings Options
          ListTile(
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.setTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  (route) => false,
                );
              }
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
