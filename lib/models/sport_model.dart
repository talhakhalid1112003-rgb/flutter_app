import 'package:flutter/material.dart';
import 'package:scoring_app/constants/app_colors.dart';

enum SportType { cricket, badminton }

class SportModel {
  const SportModel({
    required this.type,
    required this.displayName,
    required this.dashboardLabel,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.formatLabel,
    required this.formatValue,
  });

  static const String selectedSportKey = 'selected_sport';

  final SportType type;
  final String displayName;
  final String dashboardLabel;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String formatLabel;
  final String formatValue;

  String get routeName => switch (type) {
    SportType.cricket => 'cricketDashboard',
    SportType.badminton => 'badmintonDashboard',
    // SportType.tennis => 'tennisDashboard',
    // SportType.football => 'footballDashboard',
  };

  String get routePath => switch (type) {
    SportType.cricket => '/dashboard/cricket',
    SportType.badminton => '/dashboard/badminton',
    // SportType.tennis => '/dashboard/tennis',
    // SportType.football => '/dashboard/football',
  };

  static const SportModel cricket = SportModel(
    type: SportType.cricket,
    displayName: 'Cricket',
    dashboardLabel: 'Cricket Dashboard',
    subtitle: 'Overs, wickets, innings and score tracking built for cricket.',
    icon: Icons.sports_cricket,
    accentColor: AppColors.accent,
    formatLabel: 'Format',
    formatValue: 'Overs • Wickets',
  );

  static const SportModel badminton = SportModel(
    type: SportType.badminton,
    displayName: 'Badminton',
    dashboardLabel: 'Badminton Dashboard',
    subtitle: 'Track rallies, sets and point-by-point momentum.',
    icon: Icons.sports_tennis,
    accentColor: Color(0xFF6FDB7D),
    formatLabel: 'Format',
    formatValue: 'Sets • Points',
  );

  // static const SportModel tennis = SportModel(
  //   type: SportType.tennis,
  //   displayName: 'Tennis',
  //   dashboardLabel: 'Tennis Dashboard',
  //   subtitle: 'Score sets, games and points with a clean match flow.',
  //   icon: Icons.sports_tennis_outlined,
  //   accentColor: Color(0xFF7CE0B5),
  //   formatLabel: 'Format',
  //   formatValue: 'Sets • Games • Points',
  // );

  // static const SportModel football = SportModel(
  //   type: SportType.football,
  //   displayName: 'Football',
  //   dashboardLabel: 'Football Dashboard',
  //   subtitle: 'Capture goals, cards and match timing at a glance.',
  //   icon: Icons.sports_soccer,
  //   accentColor: Color(0xFF8AD16E),
  //   formatLabel: 'Format',
  //   formatValue: 'Goals • Cards',
  // );

  static const List<SportModel> allSports = [cricket, badminton];

  static SportModel fromStorageValue(String? value) {
    return allSports.firstWhere(
      (sport) => sport.type.name == value,
      orElse: () => cricket,
    );
  }
}
