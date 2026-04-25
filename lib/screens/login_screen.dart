import 'package:abandoned_cart_recovery_system/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/common_button.dart';
import '../widgets/common_textfield.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppStrings.smartCalling,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Name
                  CommonTextField(
                    controller: auth.nameController,
                    hint: AppStrings.name,
                    validator: (v) =>
                        v == null || v.isEmpty ? AppStrings.enterName : null,
                  ),

                  const SizedBox(height: 15),

                  // Email
                  CommonTextField(
                    controller: auth.emailController,
                    hint: AppStrings.email,
                    validator: (v) {
                      if (v == null || v.isEmpty) return AppStrings.enterEmail;
                      if (!v.contains("@")) return AppStrings.invalidEmail;
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // Password
                  CommonTextField(
                    controller: auth.passwordController,
                    hint: AppStrings.password,
                    obscureText: auth.obscurePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        auth.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: auth.togglePassword,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return AppStrings.enterPassword;
                      if (v.length < 4) return AppStrings.minCharacters;
                      return null;
                    },
                  ),

                  const SizedBox(height: 50),

                  // Login Button
                  CommonButton(
                    title: AppStrings.login,
                    width: 130,
                    isLoading: auth.isLoading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await auth.login();
                        if (auth.isLoggedIn) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                          );
                      }}
                    },
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
