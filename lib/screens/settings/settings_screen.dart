import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Logout"),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () async {
              await auth.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
