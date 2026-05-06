import 'package:flutter/material.dart';

class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({
    super.key,
    required this.teamId,
    required this.sportId,
    this.selectedFormat,
  });

  final String teamId;
  final String sportId;
  final String? selectedFormat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Detail')),
      body: Center(
        child: Text(
          'Team: $teamId | Sport: $sportId | Format: ${selectedFormat ?? 'N/A'}',
        ),
      ),
    );
  }
}
