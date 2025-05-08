import 'package:flutter/material.dart';

class ConsultantScaffold extends StatelessWidget {
  final Widget child;

  const ConsultantScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add drawer or menu if needed
      body: child,
    );
  }
}
