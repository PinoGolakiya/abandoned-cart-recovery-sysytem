import 'package:abandoned_cart_recovery_system/models/user_model.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/db_services.dart';

class AuthProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserModel? user;
  bool isLoading = false;
  bool obscurePassword = true;

  bool get isLoggedIn => user != null;

  // toggle password
  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // check login on splash
  Future<void> checkLogin() async {
    user = await DBService.getUser();
    notifyListeners();
  }

  // login
  Future<void> login() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      return;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final newUser = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
    );

    await DBService.saveUser(newUser.toMap());

    user = newUser;

    isLoading = false;
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  // logout
  Future<void> logout(BuildContext context) async {
    await DBService.logout();
    user = null;
    notifyListeners();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
