import 'package:flutter/material.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({
    super.key,
    required this.sportId,
    this.selectedFormat,
  });

  final String sportId;
  final String? selectedFormat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: Center(
        child: Text('Teams for: $sportId | Format: ${selectedFormat ?? 'N/A'}'),
      ),
    );
  }
}
