import 'package:flutter/material.dart';

class BadmintonDashboardScreen extends StatelessWidget {
  const BadmintonDashboardScreen({
    super.key,
    required this.sportId,
  });

  final String sportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badminton Dashboard')),
      body: Center(child: Text('Sport: $sportId')),
    );
  }
}
