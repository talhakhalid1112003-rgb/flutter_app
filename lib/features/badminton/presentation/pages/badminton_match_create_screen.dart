import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_round_summary.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_history_service.dart';
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';

class BadmintonMatchCreateScreen extends StatefulWidget {
  const BadmintonMatchCreateScreen({super.key});

  @override
  State<BadmintonMatchCreateScreen> createState() =>
      _BadmintonMatchCreateScreenState();
}

class _BadmintonMatchCreateScreenState
    extends State<BadmintonMatchCreateScreen> {
  static const int _currentIndex = 0;
  static const List<int> _pointsOptions = <int>[11, 15, 21];

  final BadmintonHistoryService _historyService = BadmintonHistoryService(
    FirebaseFirestore.instance,
  );

  final _singlePlayerAController = TextEditingController();
  final _singlePlayerBController = TextEditingController();
  final _teamANameController = TextEditingController();
  final _teamBNameController = TextEditingController();
  final _teamAPlayer1Controller = TextEditingController();
  final _teamAPlayer2Controller = TextEditingController();
  final _teamBPlayer1Controller = TextEditingController();
  final _teamBPlayer2Controller = TextEditingController();

  String _matchType = 'Singles';
  int _selectedPoints = 21;
  bool _saving = false;

  @override
  void dispose() {
    _singlePlayerAController.dispose();
    _singlePlayerBController.dispose();
    _teamANameController.dispose();
    _teamBNameController.dispose();
    _teamAPlayer1Controller.dispose();
    _teamAPlayer2Controller.dispose();
    _teamBPlayer1Controller.dispose();
    _teamBPlayer2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSportText = 'Selected sport: badminton';

    return Scaffold(
      appBar: AppBar(title: const Text('BADMINTON Scorer')),
      bottomNavigationBar: BadmintonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _goToIndex(context, index),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppTheme.cardColorDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  selectedSportText,
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Match Type'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildToggleCard('Singles', 'Players only')),
                const SizedBox(width: 12),
                Expanded(child: _buildToggleCard('Doubles', 'Teams + players')),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Team / Player Selection'),
            const SizedBox(height: 8),
            Card(
              color: AppTheme.cardColorDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _matchType == 'Singles'
                    ? Column(
                        children: [
                          TextField(
                            controller: _singlePlayerAController,
                            decoration: const InputDecoration(
                              labelText: 'Player A Name',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _singlePlayerBController,
                            decoration: const InputDecoration(
                              labelText: 'Player B Name',
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildDoubleTeamCard(
                            teamLabel: 'Team A',
                            teamNameController: _teamANameController,
                            player1Controller: _teamAPlayer1Controller,
                            player2Controller: _teamAPlayer2Controller,
                          ),
                          const SizedBox(height: 16),
                          _buildDoubleTeamCard(
                            teamLabel: 'Team B',
                            teamNameController: _teamBNameController,
                            player1Controller: _teamBPlayer1Controller,
                            player2Controller: _teamBPlayer2Controller,
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Points to Win Match?'),
            const SizedBox(height: 8),
            Card(
              color: AppTheme.cardColorDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _pointsOptions
                      .map(
                        (points) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildToggleCard(
                            '$points Points',
                            points == 11
                                ? 'Quick match'
                                : points == 15
                                ? 'Medium length'
                                : 'Standard',
                            selected: _selectedPoints == points,
                            onTap: () =>
                                setState(() => _selectedPoints = points),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saving ? null : _startMatch,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(_saving ? 'Saving...' : 'Start Match'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.primaryBlue,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildToggleCard(
    String title,
    String subtitle, {
    bool? selected,
    VoidCallback? onTap,
  }) {
    final isSelected = selected ?? _matchType == title;
    return InkWell(
      onTap: onTap ?? () => setState(() => _matchType = title),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.15)
              : AppTheme.cardColorDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.white24,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? AppTheme.primaryBlue : Colors.white54,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoubleTeamCard({
    required String teamLabel,
    required TextEditingController teamNameController,
    required TextEditingController player1Controller,
    required TextEditingController player2Controller,
  }) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              teamLabel,
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: teamNameController,
              decoration: InputDecoration(labelText: '$teamLabel Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: player1Controller,
              decoration: InputDecoration(labelText: '$teamLabel - Player 1'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: player2Controller,
              decoration: InputDecoration(labelText: '$teamLabel - Player 2'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startMatch() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to create a badminton match.'),
        ),
      );
      return;
    }

    final match = _buildInitialMatch(userId);
    if (match == null) {
      return;
    }

    setState(() => _saving = true);
    try {
      final created = await _historyService.createMatch(match);
      if (!mounted) {
        return;
      }
      context.go('/badminton/match/${created.matchId}', extra: created);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to start match: $e')));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  BadmintonMatchModel? _buildInitialMatch(String userId) {
    if (_matchType == 'Singles') {
      final playerA = _singlePlayerAController.text.trim();
      final playerB = _singlePlayerBController.text.trim();
      if (playerA.isEmpty || playerB.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both player names.')),
        );
        return null;
      }

      return BadmintonMatchModel(
        matchId: '',
        userId: userId,
        matchType: _matchType,
        selectedPoints: _selectedPoints,
        teamAName: '',
        teamBName: '',
        players: <String, List<String>>{
          'teamA': <String>[playerA],
          'teamB': <String>[playerB],
        },
        scores: <String, int>{'teamA': 0, 'teamB': 0},
        roundsWon: <String, int>{'teamA': 0, 'teamB': 0},
        finalWinner: '',
        createdAt: DateTime.now(),
        matchStatus: 'live',
        currentRound: 1,
        deuceTieCount: 0,
        suddenDeathActive: false,
        roundSummaries: const <BadmintonRoundSummary>[],
      );
    }

    final teamAName = _teamANameController.text.trim();
    final teamBName = _teamBNameController.text.trim();
    final teamAPlayer1 = _teamAPlayer1Controller.text.trim();
    final teamAPlayer2 = _teamAPlayer2Controller.text.trim();
    final teamBPlayer1 = _teamBPlayer1Controller.text.trim();
    final teamBPlayer2 = _teamBPlayer2Controller.text.trim();

    if ([
      teamAName,
      teamBName,
      teamAPlayer1,
      teamAPlayer2,
      teamBPlayer1,
      teamBPlayer2,
    ].any((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all doubles fields.')),
      );
      return null;
    }

    return BadmintonMatchModel(
      matchId: '',
      userId: userId,
      matchType: _matchType,
      selectedPoints: _selectedPoints,
      teamAName: teamAName,
      teamBName: teamBName,
      players: <String, List<String>>{
        'teamA': <String>[teamAPlayer1, teamAPlayer2],
        'teamB': <String>[teamBPlayer1, teamBPlayer2],
      },
      scores: <String, int>{'teamA': 0, 'teamB': 0},
      roundsWon: <String, int>{'teamA': 0, 'teamB': 0},
      finalWinner: '',
      createdAt: DateTime.now(),
      matchStatus: 'live',
      currentRound: 1,
      deuceTieCount: 0,
      suddenDeathActive: false,
      roundSummaries: const <BadmintonRoundSummary>[],
    );
  }

  void _goToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        return;
      case 1:
        context.go('/badminton/tournament');
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
