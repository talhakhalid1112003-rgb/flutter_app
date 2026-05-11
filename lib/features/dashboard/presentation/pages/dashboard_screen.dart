import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/models/sport_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
        children: [
          _buildCard(
            context,
            Icons.people,
            'Teams & Players',
            '/teams',
            Colors.teal,
          ),
          _buildCard(
            context,
            Icons.sports_cricket,
            'New Cricket Match',
            '/new-match',
            Colors.orange,
          ),
          _buildCard(
            context,
            Icons.sports_tennis,
            'Badminton Dashboard',
            SportModel.badminton.routePath,
            Colors.green,
            extra: const {
              'sport': SportModel.badminton,
              'sportId': 'badminton',
              'selectedFormat': 'Singles',
            },
          ),
          _buildCard(
            context,
            Icons.history,
            'Match History',
            '/history',
            Colors.blueGrey,
          ),
          _buildCard(
            context,
            Icons.leaderboard,
            'Tournaments',
            '/tournaments',
            Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    Color color, {
    Map<String, dynamic>? extra,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.push(route, extra: extra),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.14),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
