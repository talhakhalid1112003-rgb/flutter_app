import 'package:flutter/material.dart';

class CricketDashboardScreen extends StatelessWidget {
  const CricketDashboardScreen({
    super.key,
    this.sportId = 'cricket',
  });

  final String sportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cricket Dashboard')),
      body: Center(child: Text('Sport: $sportId')),
    );
  }
}
