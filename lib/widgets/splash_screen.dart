// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:stow/pages/pantry/pantry.dart';

class StowSplashScreen extends StatelessWidget {
  const StowSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset('assets/loading-utensils-2.json'),
        duration: 10000,
        nextScreen: const Pantry());
  }
}
