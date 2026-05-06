import 'package:flutter/material.dart';

class TennisDashboardScreen extends StatelessWidget {
  const TennisDashboardScreen({
    super.key,
    required this.sportId,
  });

  final String sportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tennis Dashboard')),
      body: Center(child: Text('Sport: $sportId')),
    );
  }
}
