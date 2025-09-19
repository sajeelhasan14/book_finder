import 'package:flutter/material.dart';

class SignupScreenProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
