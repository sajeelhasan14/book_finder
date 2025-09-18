import 'package:book_finder/providers/signup_screen_provider.dart';
import 'package:book_finder/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            "Sign Up",
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
                      "Create Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cinzel",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Sign up to get started",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Cinzel",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    /// Full Name
                    TextFormFieldWidget(
                      labelText: " Full Name",
                      controller: fullNameController,
                      validator: (value) =>
                          value!.isEmpty ? "Full name is required" : null,
                    ),
                    const SizedBox(height: 20),

                    /// Username
                    TextFormFieldWidget(
                      labelText: "Username",
                      controller: usernameController,
                      validator: (value) =>
                          value!.isEmpty ? "Username is required" : null,
                    ),
                    const SizedBox(height: 20),

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

                    const SizedBox(height: 20),

                    /// Confirm Password
                    TextFormFieldWidget(
                      labelText: "Confirm Password",
                      controller: confirmPasswordController,
                      obscurePassword: Provider.of<SignupScreenProvider>(
                        context,
                      ).obscureConfirmPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          Provider.of<SignupScreenProvider>(
                            context,
                            listen: false,
                          ).toggleObscureConfirmPassword();
                        },
                        icon: Icon(
                          Provider.of<SignupScreenProvider>(
                                context,
                              ).obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password confirmation is required";
                        } else if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    /// Sign Up Button
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
                            ).isLoading = true;
                            auth.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            ).then((value) => {
                              Provider.of<SignupScreenProvider>(
                              context,
                              listen: false,
                            ).isLoading = false
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                elevation: 50,
                                backgroundColor: Colors.green,
                                content: Text("Signed up successfully!"),
                              ),
                            );
                          }
                        },
                        child:
                            Provider.of<SignupScreenProvider>(context).isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign Up",
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
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
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
