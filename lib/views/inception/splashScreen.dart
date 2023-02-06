import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/frontend/appBar.dart';
import 'package:todo/views/home/home.dart';
import 'package:todo/views/inception/inception.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => !isLoggedIn ? const Inception() : const Home(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const ZeroAppBar(),
      body: Center(
        child: Lottie.asset(
          "$lottiePath/splash.json",
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}
