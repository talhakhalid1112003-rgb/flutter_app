import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_tournament_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_history_service.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_tournament_history_service.dart';
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';

class BadmintonHistoryScreen extends StatefulWidget {
  const BadmintonHistoryScreen({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<BadmintonHistoryScreen> createState() => _BadmintonHistoryScreenState();
}

class _BadmintonHistoryScreenState extends State<BadmintonHistoryScreen> {
  static const int _currentIndex = 3;
  late int _tabIndex;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTabIndex.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final matchService = BadmintonHistoryService(FirebaseFirestore.instance);
    final tournamentService = BadmintonTournamentHistoryService(
      FirebaseFirestore.instance,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badminton History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/sport-selection');
            }
          },
        ),
      ),
      bottomNavigationBar: BadmintonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _goToIndex(context, index),
      ),
      body: userId == null
          ? _buildEmptyState(
              message: 'Please sign in to view badminton history.',
              description: 'Sign in to see match and tournament records.',
              onAction: () => context.go('/login'),
              actionLabel: 'Go To Login',
            )
          : StreamBuilder<List<BadmintonMatchModel>>(
              stream: matchService.watchUserMatches(userId),
              builder: (context, matchSnapshot) {
                if (matchSnapshot.hasError) {
                  return _buildErrorState(
                    'Failed to load badminton match history: ${matchSnapshot.error}',
                    onRetry: () => setState(() {}),
                  );
                }

                return StreamBuilder<List<BadmintonTournamentModel>>(
                  stream: tournamentService.watchUserTournaments(userId),
                  builder: (context, tournamentSnapshot) {
                    if (tournamentSnapshot.hasError) {
                      return _buildErrorState(
                        'Failed to load badminton tournament history: ${tournamentSnapshot.error}',
                        onRetry: () => setState(() {}),
                      );
                    }

                    if (matchSnapshot.connectionState == ConnectionState.waiting ||
                        tournamentSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final matches = matchSnapshot.data ?? <BadmintonMatchModel>[];
                    final tournaments =
                        tournamentSnapshot.data ?? <BadmintonTournamentModel>[];

                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SegmentedButton<int>(
                            segments: const [
                              ButtonSegment<int>(
                                value: 0,
                                label: Text('Matches'),
                                icon: Icon(Icons.sports_tennis),
                              ),
                              ButtonSegment<int>(
                                value: 1,
                                label: Text('Tournament'),
                                icon: Icon(Icons.emoji_events),
                              ),
                            ],
                            selected: <int>{_tabIndex},
                            onSelectionChanged: (selected) {
                              setState(() {
                                _tabIndex = selected.first;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _tabIndex == 0
                              ? _MatchesTab(
                                  matches: matches,
                                  onCreateMatch: () => context.go('/badminton/create'),
                                )
                              : _TournamentTab(
                                  tournaments: tournaments,
                                  onCreateTournament: () => context.go('/badminton/tournament'),
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
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

  Widget _buildEmptyState({
    required String message,
    required String description,
    required VoidCallback onAction,
    required String actionLabel,
  }) {
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
                const Icon(Icons.history_toggle_off, size: 56, color: Colors.white54),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, {required VoidCallback onRetry}) {
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
                const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MatchesTab extends StatelessWidget {
  const _MatchesTab({
    required this.matches,
    required this.onCreateMatch,
  });

  final List<BadmintonMatchModel> matches;
  final VoidCallback onCreateMatch;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return Center(
        child: _HistoryEmptyCard(
          title: 'No badminton matches yet',
          subtitle: 'Create a badminton match to see match history here.',
          actionLabel: 'Create Match',
          onPressed: onCreateMatch,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _MatchHistoryCard(match: matches[index]),
    );
  }
}

class _TournamentTab extends StatelessWidget {
  const _TournamentTab({
    required this.tournaments,
    required this.onCreateTournament,
  });

  final List<BadmintonTournamentModel> tournaments;
  final VoidCallback onCreateTournament;

  @override
  Widget build(BuildContext context) {
    if (tournaments.isEmpty) {
      return Center(
        child: _HistoryEmptyCard(
          title: 'No badminton tournaments yet',
          subtitle: 'Create teams first, then start a tournament to save it here.',
          actionLabel: 'Start Tournament',
          onPressed: onCreateTournament,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tournaments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _TournamentHistoryCard(tournament: tournaments[index]),
    );
  }
}

class _HistoryEmptyCard extends StatelessWidget {
  const _HistoryEmptyCard({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_toggle_off, size: 56, color: Colors.white54),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onPressed, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _MatchHistoryCard extends StatelessWidget {
  const _MatchHistoryCard({required this.match});

  final BadmintonMatchModel match;

  @override
  Widget build(BuildContext context) {
    final displayA = match.matchType == 'Singles'
        ? (match.teamAPlayers.isNotEmpty ? match.teamAPlayers.first : 'Player A')
        : (match.teamAName.isNotEmpty ? match.teamAName : 'Team A');
    final displayB = match.matchType == 'Singles'
        ? (match.teamBPlayers.isNotEmpty ? match.teamBPlayers.first : 'Player B')
        : (match.teamBName.isNotEmpty ? match.teamBName : 'Team B');

    return Card(
      color: AppTheme.cardColorDark,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push('/badminton/match/${match.matchId}', extra: match);
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
                  Chip(label: Text(match.matchStatus.toUpperCase())),
                ],
              ),
              const SizedBox(height: 10),
              Text(displayA, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('vs $displayB', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Scores: ${match.teamAScore} - ${match.teamBScore}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text('Rounds Won: ${match.roundsWonA} - ${match.roundsWonB}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text('Winner: ${match.finalWinner.isEmpty ? 'Pending' : match.finalWinner}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text('Point limit: ${match.selectedPoints}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text('Status: ${match.matchStatus}', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TournamentHistoryCard extends StatelessWidget {
  const _TournamentHistoryCard({required this.tournament});

  final BadmintonTournamentModel tournament;

  @override
  Widget build(BuildContext context) {
    final champion = tournament.tournamentWinner.isEmpty
        ? 'Pending'
        : tournament.tournamentWinner;

    return Card(
      color: AppTheme.cardColorDark,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/badminton/tournament-history/${tournament.tournamentId}'),
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
                  Chip(label: Text(tournament.tournamentStatus.toUpperCase())),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${tournament.matchType} • First to ${tournament.pointToWin} points',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                tournament.selectedTeams.map((team) => team.teamName).join('  •  '),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text('Champion: $champion', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
