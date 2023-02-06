import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/frontend/appBar.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
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
