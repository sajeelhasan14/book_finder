// lib/providers/settings_provider.dart
import 'package:book_finder/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Provider to manage app settings (preferences & cache)
class SettingsProvider extends ChangeNotifier {
  bool searchOnType = true; // whether search happens on typing
  String coverSize = ApiConstants.defaultCoverSize;

  /// Load saved settings from SharedPreferences
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    searchOnType = prefs.getBool('searchOnType') ?? true;
    coverSize = prefs.getString('coverSize') ?? ApiConstants.defaultCoverSize;
    ApiConstants.defaultCoverSize = coverSize;
    notifyListeners();
  }

  /// Toggle search-on-type setting
  Future<void> setSearchOnType(bool v) async {
    searchOnType = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('searchOnType', v);
    notifyListeners();
  }

  /// Change book cover size setting
  Future<void> setCoverSize(String s) async {
    if (!(s == ApiConstants.coverSmall ||
        s == ApiConstants.coverMedium ||
        s == ApiConstants.coverLarge)) {
      return;
    }
    coverSize = s;
    ApiConstants.defaultCoverSize = s;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('coverSize', s);
    notifyListeners();
  }

  /// Clear cached values (like recent searches)
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentSearches');
    // Extend here for other cached items in future
  }
}
