import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_history_service.dart';
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';

class BadmintonHistoryScreen extends StatelessWidget {
  const BadmintonHistoryScreen({super.key});

  static const int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final service = BadmintonHistoryService(FirebaseFirestore.instance);

    return Scaffold(
      appBar: AppBar(title: const Text('Badminton History')),
      bottomNavigationBar: BadmintonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _goToIndex(context, index),
      ),
      body: userId == null
          ? _buildEmptyState(
              context,
              'Please sign in to view badminton history.',
            )
          : StreamBuilder<List<BadmintonMatchModel>>(
              stream: service.watchUserMatches(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildEmptyState(
                    context,
                    'Failed to load badminton history: ${snapshot.error}',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final matches = snapshot.data ?? <BadmintonMatchModel>[];
                if (matches.isEmpty) {
                  return _EmptyHistoryState(
                    onCreateMatch: () => context.go('/badminton/create'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return Card(
                      color: AppTheme.cardColorDark,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          context.push(
                            '/badminton/match/${match.matchId}',
                            extra: match,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      match.matchType,
                                      style: const TextStyle(
                                        color: AppTheme.primaryBlue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      match.matchStatus.toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _teamDisplayName(match, true),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'vs ${_teamDisplayName(match, false)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Scores: ${match.teamAScore} - ${match.teamBScore}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rounds Won: ${match.roundsWonA} - ${match.roundsWonB}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Winner: ${match.finalWinner.isEmpty ? 'Pending' : match.finalWinner}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Point limit: ${match.selectedPoints}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Match status: ${match.matchStatus}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                MaterialLocalizations.of(
                                  context,
                                ).formatFullDate(match.createdAt),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: AppTheme.cardColorDark,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }

  String _teamDisplayName(BadmintonMatchModel match, bool isTeamA) {
    if (match.matchType == 'Singles') {
      final players = isTeamA ? match.teamAPlayers : match.teamBPlayers;
      return players.isNotEmpty
          ? players.first
          : (isTeamA ? 'Player A' : 'Player B');
    }
    return isTeamA
        ? (match.teamAName.isNotEmpty ? match.teamAName : 'Team A')
        : (match.teamBName.isNotEmpty ? match.teamBName : 'Team B');
  }

  void _goToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/badminton/create');
        return;
      case 1:
        context.go('/badminton/tournament');
        return;
      case 2:
        context.go('/badminton/teams');
        return;
      case 3:
        return;
    }
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState({required this.onCreateMatch});

  final VoidCallback onCreateMatch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: AppTheme.cardColorDark,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.history_toggle_off,
                  size: 56,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No badminton matches yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create a badminton match to see history here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onCreateMatch,
                  child: const Text('Create Match'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
