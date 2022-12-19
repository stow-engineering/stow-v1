import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stow/pages/pantry/pantry.dart';

class StowSplashScreen extends StatelessWidget {
  StowSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset('assets/loading-utensils-2.json'),
        duration: 10000,
        nextScreen: Pantry());
  }
}
