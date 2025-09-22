import 'package:book_finder/providers/signup_screen_provider.dart';
import 'package:book_finder/screens/auth/signup_screen.dart';
import 'package:book_finder/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Cinzel",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cinzel",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Login to your account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Cinzel",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  /// Email
                  TextFormFieldWidget(
                    labelText: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  /// Password
                  TextFormFieldWidget(
                    labelText: "Password",
                    controller: passwordController,
                    obscurePassword: Provider.of<SignupScreenProvider>(
                      context,
                    ).obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        Provider.of<SignupScreenProvider>(
                          context,
                          listen: false,
                        ).toggleObscurePassword();
                      },
                      icon: Icon(
                        Provider.of<SignupScreenProvider>(
                              context,
                            ).obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  /// Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<SignupScreenProvider>(
                            context,
                            listen: false,
                          ).setLoading(true);
                          auth
                              .signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              )
                              .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    elevation: 50,
                                    backgroundColor: Colors.green,
                                    content: Text("Logged in successfully!"),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                                Provider.of<SignupScreenProvider>(
                                  context,
                                  listen: false,
                                ).setLoading(false);
                              })
                              .onError((error, stackTrace) {
                                Provider.of<SignupScreenProvider>(
                                  context,
                                  listen: false,
                                ).setLoading(false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    elevation: 50,
                                    backgroundColor: Colors.red,
                                    content: Text(error.toString()),
                                  ),
                                );
                              });
                        }
                      },
                      child:
                          Provider.of<SignupScreenProvider>(context).isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "Cinzel",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Back to Login
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: "Cinzel",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool? obscurePassword;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const TextFormFieldWidget({
    required this.labelText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscurePassword,
    this.suffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscurePassword ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
