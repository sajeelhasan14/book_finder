// lib/providers/settings_provider.dart
import 'package:book_finder/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsProvider extends ChangeNotifier {
  // Whether search happens automatically while typing
  bool searchOnType = true;

  // Current default cover size for book images
  String coverSize = ApiConstants.defaultCoverSize;

  // Load settings from local storage (SharedPreferences)
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // Restore saved values, fallback to defaults if not found
    searchOnType = prefs.getBool('searchOnType') ?? true;
    coverSize = prefs.getString('coverSize') ?? ApiConstants.defaultCoverSize;

    // Update global default cover size
    ApiConstants.defaultCoverSize = coverSize;
    notifyListeners(); // notify UI that settings changed
  }

  // Enable/disable "search on type" and save preference
  Future<void> setSearchOnType(bool v) async {
    searchOnType = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('searchOnType', v); // persist change
    notifyListeners();
  }

  // Change default cover size (small/medium/large) and save preference
  Future<void> setCoverSize(String s) async {
    // Only allow valid sizes defined in ApiConstants
    if (!(s == ApiConstants.coverSmall || 
          s == ApiConstants.coverMedium || 
          s == ApiConstants.coverLarge)) return;

    coverSize = s;
    ApiConstants.defaultCoverSize = s; // sync global constant
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('coverSize', s); // persist change
    notifyListeners();
  }

  // Clear cached items like recent searches
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentSearches');
    // more cache items can be removed here in the future
  }
}
