import 'package:flutter/material.dart';

class FinanceScaffold extends StatelessWidget {
  final Widget child;

  const FinanceScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add drawer or menu if needed
      body: child,
    );
  }
}
