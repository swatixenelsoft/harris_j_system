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
  late AnimationController scaleController;

  @override
  void initState() {
    super.initState();

    // Create a scale animation controller (zoom in -> zoom out)
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Tween for zoom in and out
    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.2), weight: 50), // Zoom in
      TweenSequenceItem(
          tween: Tween(begin: 1.2, end: 0.0), weight: 50), // Zoom out
    ]).animate(CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          checkLoginStatus();
        }
      });

    scaleController.forward(); // Start the animation
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final int roleId = prefs.getInt('roleId') ?? 0;

    if (!mounted) return;

    if (roleId == 6) {
      // context.go(Constant.hrDashboardScreen);
      context.go(Constant.bomDashBoardScreen);
    } else if (roleId == 11) {
      context.go(Constant.consultantDashBoardScreen);
    } else if (roleId == 7) {
      context.go(Constant.consultancyDashBoardScreen);
    } else if (roleId == 8) {
      context.go(Constant.hrDashboardScreen);
    }
    else if(roleId==10){
      context.go(Constant.operatorDashboardScreen);

    }
    else {
      context.go(Constant.onBoard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: scaleAnimation.value,
          child: Image.asset(
            "assets/images/bom/bom_logo.png",
            width: 250,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }
}
