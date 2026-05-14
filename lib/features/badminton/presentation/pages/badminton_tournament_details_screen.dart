import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_tournament_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_tournament_history_service.dart';

class BadmintonTournamentDetailsScreen extends StatelessWidget {
  const BadmintonTournamentDetailsScreen({
    super.key,
    required this.tournamentId,
  });

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    final service = BadmintonTournamentHistoryService(FirebaseFirestore.instance);

    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Details')),
      body: FutureBuilder<BadmintonTournamentModel?>(
        future: service.getTournamentById(tournamentId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState('Failed to load tournament: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tournament = snapshot.data;
          if (tournament == null) {
            return _buildErrorState('Tournament not found.');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildChampionCard(tournament),
                const SizedBox(height: 16),
                _buildInfoCard(
                  title: 'Tournament Info',
                  children: [
                    _infoRow('Tournament ID', tournament.tournamentId),
                    _infoRow('Status', tournament.tournamentStatus),
                    _infoRow(
                      'Date',
                      MaterialLocalizations.of(context).formatFullDate(
                        tournament.createdAt,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTeamsCard(tournament),
                const SizedBox(height: 16),
                _buildMatchCard(
                  context,
                  title: 'Semifinal 1',
                  match: tournament.semifinal1,
                ),
                const SizedBox(height: 16),
                _buildMatchCard(
                  context,
                  title: 'Semifinal 2',
                  match: tournament.semifinal2,
                ),
                const SizedBox(height: 16),
                _buildMatchCard(
                  context,
                  title: 'Final Match',
                  match: tournament.finalMatch,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
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

  Widget _buildChampionCard(BadmintonTournamentModel tournament) {
    final champion = tournament.tournamentWinner.isEmpty
        ? 'Pending'
        : tournament.tournamentWinner;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Card(
        color: AppTheme.cardColorDark,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.emoji_events, size: 52, color: AppTheme.primaryBlue),
              const SizedBox(height: 12),
              const Text(
                'Tournament Champion',
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                champion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamsCard(BadmintonTournamentModel tournament) {
    return _buildInfoCard(
      title: 'Teams Participated',
      children: tournament.selectedTeams
          .map(
            (team) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                color: Colors.white.withValues(alpha: 0.03),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.teamName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...team.players.map(
                        (player) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $player',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMatchCard(
    BuildContext context, {
    required String title,
    required BadmintonMatchModel? match,
  }) {
    return _buildInfoCard(
      title: title,
      children: match == null
          ? const [Text('Pending', style: TextStyle(color: Colors.white70))]
          : [
              Text(
                '${_matchLabel(match, true)} vs ${_matchLabel(match, false)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _infoRow('Winner', match.finalWinner.isEmpty ? 'Pending' : match.finalWinner),
              _infoRow('Scores', '${match.teamAScore} - ${match.teamBScore}'),
              _infoRow('Rounds Won', '${match.roundsWonA} - ${match.roundsWonB}'),
              _infoRow('Match Status', match.matchStatus),
              _infoRow(
                'Date',
                MaterialLocalizations.of(context).formatFullDate(match.createdAt),
              ),
            ],
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _matchLabel(BadmintonMatchModel match, bool isTeamA) {
    if (match.matchType == 'Singles') {
      final players = isTeamA ? match.teamAPlayers : match.teamBPlayers;
      return players.isNotEmpty ? players.first : (isTeamA ? 'Player A' : 'Player B');
    }

    return isTeamA
        ? (match.teamAName.isNotEmpty ? match.teamAName : 'Team A')
        : (match.teamBName.isNotEmpty ? match.teamBName : 'Team B');
  }
}