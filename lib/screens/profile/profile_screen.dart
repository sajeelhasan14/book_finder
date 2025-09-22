import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: auth.isSignedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      auth.user?.email!.substring(0, 1).toUpperCase() ?? "U",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Email: ${auth.user?.email ?? ''}"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => auth.signOut(),
                    child: const Text("Logout"),
                  ),
                ],
              )
            : const Text("No user logged in"),
      ),
    );
  }
}
