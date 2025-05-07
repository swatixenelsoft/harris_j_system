import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // Scale animation controller (for zoom in)
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
          // Start rotation animation once zoom-in is done
          rotationController.forward();
        }
      });

    // Rotation animation controller (for continuous rotation)
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      upperBound: 2 * 3.1416, // Full 360-degree rotation in radians
    );

    rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.1416)
        .animate(rotationController);

    rotationController.repeat(); // Infinite rotation

    // Start zoom animation
    scaleController.forward();

    _navigation();
  }

  Future<void> _navigation() async {
    await Future.delayed(const Duration(seconds: 3));

    /// Ensure navigation happens after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    if (isLoggedIn) {
      context.go(Constant.bomDashBoardScreen); // Navigate to home
    } else {
      context.go(Constant.onBoard); // Navigate to onboarding
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Apply rotation after zoom-in
        child: Transform.rotate(
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
