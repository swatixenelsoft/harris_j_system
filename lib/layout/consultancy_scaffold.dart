import 'package:flutter/material.dart';

class ConsultancyScaffold extends StatelessWidget {
  final Widget child;

  const ConsultancyScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add drawer or menu if needed
      body: child,
    );
  }
}
