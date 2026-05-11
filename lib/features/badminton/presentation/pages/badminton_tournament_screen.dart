import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';

class BadmintonTournamentScreen extends StatelessWidget {
  const BadmintonTournamentScreen({super.key});

  static const int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badminton Tournament')),
      bottomNavigationBar: BadmintonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _goToIndex(context, index),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: AppTheme.cardColorDark,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 56, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Badminton tournament tools coming soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This route is kept badminton-specific so the cricket module stays untouched.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/badminton/create');
        return;
      case 1:
        return;
      case 2:
        context.go('/badminton/teams');
        return;
      case 3:
        context.go('/badminton/history');
        return;
    }
  }
}
