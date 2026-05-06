import 'package:flutter/material.dart';

class FootballDashboardScreen extends StatelessWidget {
  const FootballDashboardScreen({
    super.key,
    required this.sportId,
  });

  final String sportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Football Dashboard')),
      body: Center(child: Text('Sport: $sportId')),
    );
  }
}
