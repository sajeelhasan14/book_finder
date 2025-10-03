import 'package:book_finder/providers/bottom_navigation_provider.dart';
import 'package:book_finder/screens/favorite/favorite_screen.dart';
import 'package:book_finder/screens/home/home_screen.dart';
import 'package:book_finder/screens/profile/profile_screen.dart';

import 'package:book_finder/screens/search/search_screen.dart';
import 'package:book_finder/screens/settings/settings_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(),
      SearchScreen(),
      FavoriteScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      body: pages[Provider.of<BottomNavigationProvider>(context).currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        currentIndex: Provider.of<BottomNavigationProvider>(
          context,
        ).currentIndex,
        onTap: Provider.of<BottomNavigationProvider>(
          context,
          listen: false,
        ).toggleIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Settings"),
        ],
      ),
    );
  }
}
