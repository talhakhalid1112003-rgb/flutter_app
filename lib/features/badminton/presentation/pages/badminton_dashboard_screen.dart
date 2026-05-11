import 'package:flutter/material.dart';
import 'package:scoring_app/features/badminton/presentation/pages/sport_dashboard_screen.dart';
import 'package:scoring_app/models/sport_model.dart';

class BadmintonDashboardScreen extends StatelessWidget {
  const BadmintonDashboardScreen({
    super.key,
    required this.sport,
    required this.sportId,
    required this.selectedFormat,
  });

  final SportModel sport;
  final String sportId;
  final String selectedFormat;

  @override
  Widget build(BuildContext context) {
    return SportDashboardScreen(
      sport: sport,
      sportId: sportId,
      selectedFormat: selectedFormat,
    );
  }
}
