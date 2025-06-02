import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> scaleAnimation;
  late Animation<double> rotationAnimation;
  late AnimationController scaleController;
  late AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    _startAnimations();
    _navigateAfterDelay();
  }

  void _startAnimations() {
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    scaleAnimation = Tween<double>(begin: 0, end: 250)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(scaleController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rotationController.forward();
        }
      });

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      upperBound: 2 * 3.1416,
    );

    rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.1416)
        .animate(rotationController);

    rotationController.repeat();
    scaleController.forward();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
<<<<<<< Updated upstream

    if (isLoggedIn) {
      context.go(Constant.bomDashBoardScreen); // Navigate to home
    } else {
      context.go(Constant.onBoard); // Navigate to onboarding
    }
=======
    context.go(Constant.operatorDashboardScreen);
>>>>>>> Stashed changes
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: scaleAnimation == null || rotationAnimation == null
            ? const SizedBox()
            : Transform.rotate(
          angle: rotationAnimation.value,
          child: SizedBox(
            width: scaleAnimation.value,
            child: Image.asset('assets/icons/splash_icon.png'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scaleController.dispose();
    rotationController.dispose();
    super.dispose();
  }
}
