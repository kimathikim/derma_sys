import 'package:flutter/material.dart';
import 'package:dermasys_flutter/themes/theme.dart';
import 'package:dermasys_flutter/screens/auth/login_screen.dart';
import 'package:dermasys_flutter/patient_main.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DermaSys',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
