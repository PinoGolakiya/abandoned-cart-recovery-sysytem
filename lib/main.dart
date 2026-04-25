import 'package:abandoned_cart_recovery_system/core/theme/app_theme.dart';
import 'package:abandoned_cart_recovery_system/providers/auth_provider.dart';
import 'package:abandoned_cart_recovery_system/providers/call_provider.dart';
import 'package:abandoned_cart_recovery_system/providers/cart_provider.dart';
import 'package:abandoned_cart_recovery_system/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
