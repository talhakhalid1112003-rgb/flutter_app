import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cricket_scorer/features/matches/presentation/providers/match_providers.dart';
import 'package:smart_cricket_scorer/core/config/app_theme.dart';
import 'package:smart_cricket_scorer/core/providers/firebase_providers.dart';
import 'package:go_router/go_router.dart';

class MatchHistoryScreen extends ConsumerWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Easy Cricket Scorer')),
      body: matchesAsync.when(
        data: (matches) {
          final independentMatches = matches.where((m) => m.tournamentId == null).toList();

          if (independentMatches.isEmpty) return const Center(child: Text("No independent matches found.", style: TextStyle(color: Colors.grey)));
          
          return ListView.builder(
            itemCount: independentMatches.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final match = independentMatches[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: AppTheme.cardColorDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Match Date Placeholder', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppTheme.primaryBlue,
                                child: Text(match.teamAName.substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                              const SizedBox(width: 8),
                              Text(match.teamAName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Text('0/0 (0.0)', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppTheme.primaryBlue,
                                child: Text(match.teamBName.substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                              const SizedBox(width: 8),
                              Text(match.teamBName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Text('0/0 (0.0)', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('${match.tossWinner} won the toss and opted to ${match.tossDecision} first.', style: const TextStyle(color: AppTheme.primaryBlue, fontStyle: FontStyle.italic, fontSize: 12)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // Resume Match
                              try {
                                final snap = await ref.read(firestoreProvider)
                                    .collection('matches')
                                    .doc(match.matchId)
                                    .collection('innings')
                                    .limit(1)
                                    .get();
                                if (snap.docs.isNotEmpty) {
                                  final inningsId = snap.docs.first.id;
                                  if (context.mounted) {
                                    context.push('/scoring/${match.matchId}/$inningsId');
                                  }
                                } else {
                                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No innings found to resume.')));
                                }
                              } catch (e) {
                                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                            child: const Text('Resume'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                            child: const Text('Score board'),
                          ),
                          const SizedBox(width: 16),
                          Text(match.matchStatus == 'live' ? 'Ongoing' : 'Completed', style: TextStyle(color: match.matchStatus == 'live' ? Colors.amber : Colors.grey, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              // Delete Match
                              final bool? confirm = await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Match'),
                                  content: const Text('Are you sure you want to delete this match?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await ref.read(firestoreProvider).collection('matches').doc(match.matchId).delete();
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
