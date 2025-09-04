import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/screens/auth_screen/auth_screen.dart';
import 'package:task_manager_app/screens/homeScreen/home_screen.dart';

class AuthGateway extends StatelessWidget {
  const AuthGateway({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If user is logged in
          if (snapshot.hasData && snapshot.data != null) {
            return HomeScreen();
          }

          // If user is not logged in
          return const AuthScreen();
        },
      ),
    );
  }
}
