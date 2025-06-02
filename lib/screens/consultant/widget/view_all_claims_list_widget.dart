import 'package:flutter/material.dart';
import 'package:harris_j_system/widgets/custom_table.dart';

class FullClaimsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> allClaims;
  final List<Map<String, String>> heading;

  const FullClaimsScreen({
    super.key,
    required this.allClaims,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Claims"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomTableView(
          data: allClaims,
          heading: heading,
        ),
      ),
    );
  }
}
