import 'package:book_finder/providers/auth_provider.dart';
import 'package:book_finder/providers/author_provider.dart';
import 'package:book_finder/providers/editions_provider.dart';
import 'package:book_finder/providers/favorite_provider.dart';
import 'package:book_finder/providers/search_provider.dart';
import 'package:book_finder/providers/settings_provider.dart';
import 'package:book_finder/providers/signup_screen_provider.dart';
import 'package:book_finder/providers/subject_provider.dart';
import 'package:book_finder/providers/work_detail_provider.dart';

import 'package:book_finder/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuthorProvider()),
        ChangeNotifierProvider(create: (_) => EditionsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SignupScreenProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => WorkDetailProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
