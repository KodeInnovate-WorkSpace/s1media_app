import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s1media_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(Icons.login))
        ],
      ),
      backgroundColor: Colors.white,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text("Hello S1 Media"))],
      ),
    );
  }
}
