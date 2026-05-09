import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/constants/app_colors.dart';
import 'package:scoring_app/models/sport_model.dart';

class SportSelectionScreen extends StatelessWidget {
  const SportSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a sport')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select the game for which you want to calculate the score.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: SportModel.allSports.length,
                itemBuilder: (context, index) {
                  final sport = SportModel.allSports[index];
                  return Material(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (sport.type == SportType.badminton) {
                          context.go('/badminton-format-screen');
                          return;
                        }
                        context.go('/new-match?sportId=${sport.type.name}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: sport.accentColor.withOpacity(0.18),
                              child: Icon(sport.icon, color: sport.accentColor, size: 28),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              sport.displayName,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                sport.subtitle,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
