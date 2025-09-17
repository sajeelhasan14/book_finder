import 'package:flutter/material.dart';

class SignupScreenProvider extends ChangeNotifier {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void toggleObscurePassword(){
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword(){
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

}