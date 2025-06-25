import 'package:flutter/material.dart';

class BomScaffold extends StatelessWidget {
  final Widget child;

  const BomScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add drawer or menu if needed
      body: child,
    );
  }
}