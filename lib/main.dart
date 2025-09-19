import 'package:book_finder/providers/signup_screen_provider.dart';
import 'package:book_finder/screens/auth/login_screen.dart';
import 'package:book_finder/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';   



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupScreenProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SignUpScreen(),
      ),
    );
  }
}


