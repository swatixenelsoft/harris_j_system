import 'package:flutter/material.dart';

class OperatorScaffold extends StatelessWidget {
  final Widget child;

  const OperatorScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add drawer or menu if needed
      body: child,
    );
  }
}