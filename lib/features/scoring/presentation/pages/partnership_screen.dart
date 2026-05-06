import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cricket_scorer/core/config/app_theme.dart';

class PartnershipScreen extends ConsumerWidget {
  final String matchId;
  final String inningsId;

  const PartnershipScreen({
    super.key,
    required this.matchId,
    required this.inningsId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Here we can fetch the actual partnership stats from providers.
    // For now, we will display a mock or basic UI for the partnership.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partnership Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColorDark,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    'Current Partnership',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Batsman 1', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('45 (30)', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('--- Partnership: 60 (45) ---', style: TextStyle(color: Colors.white54)),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Batsman 2', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('15 (15)', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Previous Partnerships',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Mock data count
                itemBuilder: (context, index) {
                  return Card(
                    color: AppTheme.cardColorDark,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text('Wicket ${index + 1}: 35 runs', style: const TextStyle(color: Colors.white)),
                      subtitle: const Text('Batsman A & Batsman B', style: TextStyle(color: Colors.white54)),
                      trailing: const Text('20 balls', style: TextStyle(color: AppTheme.primaryBlue)),
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
