import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text('Signup',style: TextStyle(
          fontFamily: "Cinzel",
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
      ),
      body: Center(
        child: Text('Signup Screen'),
      ),
    );
  }
}