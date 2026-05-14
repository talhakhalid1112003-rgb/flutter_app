import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_round_summary.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_history_service.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_team_service.dart';
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

  final BadmintonTeamService _teamService = BadmintonTeamService(
    FirebaseFirestore.instance,
  );

  final _singlePlayerAController = TextEditingController();
  final _singlePlayerBController = TextEditingController();

  // Doubles mode team selection
  String? _selectedTeamAId;
  String? _selectedTeamBId;
  BadmintonTeamModel? _selectedTeamA;
  BadmintonTeamModel? _selectedTeamB;

  String _matchType = 'Singles';
  int _selectedPoints = 21;
  bool _saving = false;

  @override
  void dispose() {
    _singlePlayerAController.dispose();
    _singlePlayerBController.dispose();
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
                    : _buildDoublesTeamSelection(),
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

  /// Build doubles team selection UI with StreamBuilder and dropdowns
  Widget _buildDoublesTeamSelection() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Sign in to load your doubles teams.',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      );
    }

    return StreamBuilder<List<BadmintonTeamModel>>(
      stream: _teamService.watchCurrentUserTeams(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Error loading teams: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        final teams = snapshot.data ?? <BadmintonTeamModel>[];

        if (teams.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No teams available. Please create teams first.',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Team A Dropdown
            _buildTeamDropdown(
              teamLabel: 'Team A',
              teams: teams,
              selectedTeamId: _selectedTeamAId,
              selectedTeam: _selectedTeamA,
              excludedTeamId: _selectedTeamBId,
              onChanged: (teamId) {
                setState(() {
                  _selectedTeamAId = teamId;
                  _selectedTeamA = _teamFromId(teams, teamId);
                  if (_selectedTeamBId == teamId) {
                    _selectedTeamBId = null;
                    _selectedTeamB = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            // Team A Players Display
            if (_selectedTeamA != null)
              _buildTeamPlayersDisplay(
                teamName: _selectedTeamA!.teamName,
                players: _selectedTeamA!.players,
              ),
            if (_selectedTeamA != null) const SizedBox(height: 16),
            // Team B Dropdown
            _buildTeamDropdown(
              teamLabel: 'Team B',
              teams: teams,
              selectedTeamId: _selectedTeamBId,
              selectedTeam: _selectedTeamB,
              excludedTeamId: _selectedTeamAId,
              onChanged: (teamId) {
                setState(() {
                  _selectedTeamBId = teamId;
                  _selectedTeamB = _teamFromId(teams, teamId);
                });
              },
            ),
            const SizedBox(height: 16),
            // Team B Players Display
            if (_selectedTeamB != null)
              _buildTeamPlayersDisplay(
                teamName: _selectedTeamB!.teamName,
                players: _selectedTeamB!.players,
              ),
          ],
        );
      },
    );
  }

  /// Build dropdown for team selection
  Widget _buildTeamDropdown({
    required String teamLabel,
    required List<BadmintonTeamModel> teams,
    required String? selectedTeamId,
    required BadmintonTeamModel? selectedTeam,
    required ValueChanged<String?> onChanged,
    required String? excludedTeamId,
  }) {
    final validSelectedTeamId = teams.any((team) => team.id == selectedTeamId)
        ? selectedTeamId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          teamLabel,
          style: const TextStyle(
            color: AppTheme.primaryBlue,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: validSelectedTeamId,
          onChanged: (team) {
            onChanged(team);
          },
          items: teams
              .map(
                (team) => DropdownMenuItem<String>(
                  value: team.id,
                  enabled: team.id != excludedTeamId,
                  child: Opacity(
                    opacity: team.id != excludedTeamId ? 1.0 : 0.5,
                    child: Text(team.teamName),
                  ),
                ),
              )
              .toList(),
          decoration: InputDecoration(
            hintText: 'Select $teamLabel',
            filled: true,
            fillColor: AppTheme.cardColorDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white24),
            ),
          ),
          dropdownColor: AppTheme.cardColorDark,
          style: const TextStyle(color: Colors.white),
        ),
        if (selectedTeam != null && excludedTeamId != null && selectedTeam.id == excludedTeamId)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Same team cannot be selected twice',
              style: TextStyle(color: Colors.red[400], fontSize: 12),
            ),
          ),
      ],
    );
  }

  BadmintonTeamModel? _teamFromId(
    List<BadmintonTeamModel> teams,
    String? teamId,
  ) {
    if (teamId == null) {
      return null;
    }

    for (final team in teams) {
      if (team.id == teamId) {
        return team;
      }
    }
    return null;
  }

  /// Build player display for selected team
  Widget _buildTeamPlayersDisplay({
    required String teamName,
    required List<String> players,
  }) {
    return Card(
      color: AppTheme.cardColorDark.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$teamName Players',
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...players
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                ,
          ],
        ),
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

    // Doubles mode
    if (_selectedTeamA == null || _selectedTeamB == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both Team A and Team B.')),
      );
      return null;
    }

    // Validation: Same team cannot be selected twice
    if (_selectedTeamA!.id == _selectedTeamB!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team A and Team B must be different teams.'),
        ),
      );
      return null;
    }

    return BadmintonMatchModel(
      matchId: '',
      userId: userId,
      matchType: _matchType,
      selectedPoints: _selectedPoints,
      teamAName: _selectedTeamA!.teamName,
      teamBName: _selectedTeamB!.teamName,
      players: <String, List<String>>{
        'teamA': _selectedTeamA!.players,
        'teamB': _selectedTeamB!.players,
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
