import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_tournament_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_tournament_history_service.dart';

class BadmintonTournamentHistoryScreen extends StatelessWidget {
  const BadmintonTournamentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final service = BadmintonTournamentHistoryService(FirebaseFirestore.instance);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: userId == null
          ? _buildEmptyState(
              message: 'Please sign in to view badminton tournament history.',
            )
          : StreamBuilder<List<BadmintonTournamentModel>>(
              stream: service.watchUserTournaments(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildEmptyState(
                    message: 'Failed to load tournament history: ${snapshot.error}',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tournaments = snapshot.data ?? <BadmintonTournamentModel>[];
                if (tournaments.isEmpty) {
                  return _buildEmptyState(
                    message: 'No badminton tournaments have been saved yet.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: tournaments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final tournament = tournaments[index];
                    return Card(
                      color: AppTheme.cardColorDark,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          context.push(
                            '/badminton/tournament-history/${tournament.tournamentId}',
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
                                      tournament.tournamentId,
                                      style: const TextStyle(
                                        color: AppTheme.primaryBlue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      tournament.tournamentStatus.toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _teamNames(tournament),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Semifinal winners: ${_matchWinner(tournament.semifinal1)} | ${_matchWinner(tournament.semifinal2)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Final winner: ${_matchWinner(tournament.finalMatch)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Champion: ${tournament.tournamentWinner.isEmpty ? 'Pending' : tournament.tournamentWinner}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                MaterialLocalizations.of(
                                  context,
                                ).formatFullDate(tournament.createdAt),
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

  Widget _buildEmptyState({required String message}) {
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

  String _teamNames(BadmintonTournamentModel tournament) {
    if (tournament.selectedTeams.isEmpty) {
      return 'No teams recorded';
    }
    return tournament.selectedTeams.map((team) => team.teamName).join('  •  ');
  }

  String _matchWinner(BadmintonMatchModel? match) {
    if (match == null) {
      return 'Pending';
    }
    return match.finalWinner.isEmpty ? 'Pending' : match.finalWinner;
  }
}