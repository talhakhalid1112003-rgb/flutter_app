import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_round_summary.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_tournament_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_history_service.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_team_service.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_tournament_history_service.dart';
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';

enum _TournamentPhase { selection, semifinals, finalMatch, completed }

class BadmintonTournamentScreen extends StatefulWidget {
  const BadmintonTournamentScreen({super.key});

  @override
  State<BadmintonTournamentScreen> createState() =>
      _BadmintonTournamentScreenState();
}

class _BadmintonTournamentScreenState extends State<BadmintonTournamentScreen> {
  static const int _currentIndex = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BadmintonTeamService _teamService = BadmintonTeamService(
    FirebaseFirestore.instance,
  );
  final BadmintonHistoryService _matchHistoryService = BadmintonHistoryService(
    FirebaseFirestore.instance,
  );
  final BadmintonTournamentHistoryService _tournamentHistoryService =
      BadmintonTournamentHistoryService(FirebaseFirestore.instance);

  final List<String?> _selectedTeamIds = List<String?>.filled(4, null);

  _TournamentPhase _phase = _TournamentPhase.selection;
  bool isTournamentProcessing = false;
  bool _isSavingTournament = false;
  String? _errorMessage;
  String? _stageMessage;

  BadmintonTournamentModel? _tournamentRecord;
  List<_BracketMatch> _semifinals = <_BracketMatch>[];
  BadmintonMatchModel? _activeMatch;
  int _activeMatchIndex = -1;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badminton Tournament'),
        actions: [
          IconButton(
            tooltip: 'Tournament History',
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/badminton/tournament-history'),
          ),
        ],
      ),
      bottomNavigationBar: BadmintonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _goToIndex(context, index),
      ),
      body: user == null
          ? _buildEmptyState('Please sign in to create badminton tournaments.')
          : StreamBuilder<List<BadmintonTeamModel>>(
              stream: _teamService.watchCurrentUserTeams(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildEmptyState(
                    'Failed to load your badminton teams: ${snapshot.error}',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final teams = snapshot.data ?? <BadmintonTeamModel>[];
                if (_phase == _TournamentPhase.selection) {
                  return _buildSelectionView(teams);
                }

                return _buildTournamentView();
              },
            ),
    );
  }

  Widget _buildSelectionView(List<BadmintonTeamModel> teams) {
    final canStart = teams.length >= 4;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppTheme.cardColorDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tournament Setup',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select exactly 4 different badminton teams from your Firestore teams.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (teams.length < 4)
              _buildEmptyState(
                'You need at least 4 badminton teams to start a tournament.',
              )
            else
              ...List<Widget>.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTeamSelector(
                    label: 'Team ${index + 1}',
                    index: index,
                    teams: teams,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: !canStart || isTournamentProcessing
                  ? null
                  : () => _startTournament(teams),
              icon: const Icon(Icons.emoji_events),
              label: Text(
                isTournamentProcessing ? 'Starting Tournament...' : 'Start Tournament',
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSelector({
    required String label,
    required int index,
    required List<BadmintonTeamModel> teams,
  }) {
    final selectedIds = _selectedTeamIds.whereType<String>().toSet();
    final selectedTeamId = _selectedTeamIds[index];
    final selectedTeam = _selectedTeamFromTeams(teams, selectedTeamId);

    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedTeamId,
              decoration: const InputDecoration(labelText: 'Select team'),
              items: teams
                  .map(
                    (team) => DropdownMenuItem<String>(
                      value: team.id,
                      enabled: team.id == selectedTeamId || !selectedIds.contains(team.id),
                      child: Opacity(
                        opacity:
                            team.id == selectedTeamId || !selectedIds.contains(team.id)
                                ? 1
                                : 0.45,
                        child: Text(team.teamName),
                      ),
                    ),
                  )
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a team.';
                }
                if (_selectedTeamIds.where((id) => id == value).length > 1) {
                  return 'Same team cannot be selected twice.';
                }
                return null;
              },
              onChanged: isTournamentProcessing
                  ? null
                  : (value) {
                      setState(() {
                        _selectedTeamIds[index] = value;
                        _errorMessage = null;
                      });
                    },
            ),
            const SizedBox(height: 12),
            if (selectedTeam != null) _buildTeamPlayersCard(selectedTeam),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamPlayersCard(BadmintonTeamModel team) {
    return Card(
      color: AppTheme.cardColorDark.withValues(alpha: 0.72),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              team.teamName,
              style: const TextStyle(
                color: AppTheme.primaryBlue,
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
    );
  }

  Widget _buildTournamentView() {
    final activeMatch = _activeMatch;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_stageMessage != null)
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 250),
              child: Card(
                color: AppTheme.cardColorDark,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.sports_tennis, color: AppTheme.primaryBlue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _stageMessage!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Card(
              color: Colors.red.withValues(alpha: 0.18),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildBracketSummaryCard(),
          const SizedBox(height: 16),
          if (activeMatch != null)
            _TournamentMatchView(
              match: activeMatch,
              title: _activeMatchTitle(),
              onMatchCompleted: _handleMatchCompleted,
            )
          else if (_phase == _TournamentPhase.completed)
            _buildChampionCard()
          else
            _buildEmptyState('Preparing tournament bracket...'),
          const SizedBox(height: 16),
          if (_phase == _TournamentPhase.completed)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.push('/badminton/tournament-history'),
                  icon: const Icon(Icons.history),
                  label: const Text('View Tournament History'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: isTournamentProcessing ? null : _resetTournament,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Start New Tournament'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBracketSummaryCard() {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tournament Bracket',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildBracketRow(
              label: 'Semifinal 1',
              left: _semifinals.isNotEmpty ? _semifinals[0].teamA.teamName : 'Pending',
              right: _semifinals.isNotEmpty ? _semifinals[0].teamB.teamName : 'Pending',
              winner: _semifinalWinnerName(0),
            ),
            const SizedBox(height: 12),
            _buildBracketRow(
              label: 'Semifinal 2',
              left: _semifinals.length > 1 ? _semifinals[1].teamA.teamName : 'Pending',
              right: _semifinals.length > 1 ? _semifinals[1].teamB.teamName : 'Pending',
              winner: _semifinalWinnerName(1),
            ),
            const SizedBox(height: 12),
            _buildBracketRow(
              label: 'Final',
              left: _finalTeamsLabel(true),
              right: _finalTeamsLabel(false),
              winner: _finalWinnerName(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBracketRow({
    required String label,
    required String left,
    required String right,
    required String winner,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text('$left vs $right', style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            'Winner: ${winner.isEmpty ? 'Pending' : winner}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildChampionCard() {
    final champion = _tournamentRecord?.tournamentWinner ?? 'Pending';
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Card(
        color: AppTheme.cardColorDark,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.emoji_events, size: 56, color: AppTheme.primaryBlue),
              const SizedBox(height: 12),
              const Text(
                'Tournament Winner',
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                champion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetTournament() {
    setState(() {
      _selectedTeamIds.fillRange(0, _selectedTeamIds.length, null);
      _phase = _TournamentPhase.selection;
      isTournamentProcessing = false;
      _errorMessage = null;
      _stageMessage = null;
      _tournamentRecord = null;
      _semifinals = <_BracketMatch>[];
      _activeMatch = null;
      _activeMatchIndex = -1;
    });
  }

  Widget _buildEmptyState(String message) {
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

  Future<void> _startTournament(List<BadmintonTeamModel> teams) async {
    if (isTournamentProcessing) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final selectedTeams = _selectedTeamIds
        .map((teamId) => _selectedTeamFromTeams(teams, teamId))
        .whereType<BadmintonTeamModel>()
        .toList();

    if (selectedTeams.length != 4 || selectedTeams.map((team) => team.id).toSet().length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select exactly 4 unique teams.')),
      );
      return;
    }

    final shuffledTeams = [...selectedTeams]..shuffle(Random());
    final semifinals = <_BracketMatch>[
      _BracketMatch(
        label: 'Semifinal 1',
        teamA: shuffledTeams[0],
        teamB: shuffledTeams[1],
      ),
      _BracketMatch(
        label: 'Semifinal 2',
        teamA: shuffledTeams[2],
        teamB: shuffledTeams[3],
      ),
    ];

    setState(() {
      isTournamentProcessing = true;
      _errorMessage = null;
      _stageMessage = 'Shuffling teams and preparing semifinals...';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('You must be signed in to start a tournament.');
      }

      final draft = BadmintonTournamentModel(
        tournamentId: '',
        userId: user.uid,
        createdAt: DateTime.now(),
        selectedTeams: selectedTeams,
        semifinal1: null,
        semifinal2: null,
        finalMatch: null,
        tournamentWinner: '',
        tournamentStatus: 'in_progress',
      );

      final savedTournament = await _tournamentHistoryService.saveTournament(draft);
      if (!mounted) {
        return;
      }

      setState(() {
        _tournamentRecord = savedTournament;
        _semifinals = semifinals;
        _activeMatchIndex = 0;
        _phase = _TournamentPhase.semifinals;
        _stageMessage = 'Semifinal 1 begins now.';
      });

      await _prepareActiveMatch(semifinals[0]);
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Failed to start tournament: $e';
        isTournamentProcessing = false;
        _phase = _TournamentPhase.selection;
      });
    }
  }

  Future<void> _prepareActiveMatch(_BracketMatch bracketMatch) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to create a badminton match.');
    }

    final created = await _matchHistoryService.createMatch(
      _buildInitialMatch(
        userId: user.uid,
        teamA: bracketMatch.teamA,
        teamB: bracketMatch.teamB,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _activeMatch = created;
    });
  }

  Future<void> _handleMatchCompleted(BadmintonMatchModel completedMatch) async {
    if (!mounted || _tournamentRecord == null) {
      return;
    }

    final currentBracket = _activeMatchIndex < _semifinals.length
        ? _semifinals[_activeMatchIndex]
        : null;
    if (currentBracket == null) {
      return;
    }

    final updatedTournament = _buildUpdatedTournamentRecord(
      completedMatch: completedMatch,
      matchIndex: _activeMatchIndex,
    );

    setState(() {
      _tournamentRecord = updatedTournament;
      _activeMatch = null;
      _stageMessage = '${currentBracket.label} complete. ${completedMatch.finalWinner} advances.';
    });

    await _saveTournamentSafely(updatedTournament);

    if (!mounted) {
      return;
    }

    if (_activeMatchIndex == 0) {
      _activeMatchIndex = 1;
      _stageMessage = 'Semifinal 2 begins now.';
      await Future<void>.delayed(const Duration(milliseconds: 800));
      await _prepareActiveMatch(_semifinals[1]);
      return;
    }

    if (_activeMatchIndex == 1) {
      final finalists = _finalistsFromSemifinals();
      _activeMatchIndex = 2;
      _phase = _TournamentPhase.finalMatch;
      _stageMessage = 'The final match begins now.';

      await Future<void>.delayed(const Duration(milliseconds: 800));
      await _prepareFinalMatch(finalists);
      return;
    }

    final completedTournament = updatedTournament.copyWith(
      finalMatch: completedMatch,
      tournamentWinner: completedMatch.finalWinner,
      tournamentStatus: 'completed',
    );

    setState(() {
      _tournamentRecord = completedTournament;
      _phase = _TournamentPhase.completed;
      isTournamentProcessing = false;
      _stageMessage = 'Tournament Winner: ${completedMatch.finalWinner}';
      _activeMatch = null;
    });

    await _saveTournamentSafely(completedTournament);
  }

  Future<void> _prepareFinalMatch(List<BadmintonTeamModel> finalists) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to create the final match.');
    }

    final created = await _matchHistoryService.createMatch(
      _buildInitialMatch(
        userId: user.uid,
        teamA: finalists[0],
        teamB: finalists[1],
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _activeMatch = created;
    });
  }

  Future<void> _saveTournamentSafely(BadmintonTournamentModel record) async {
    if (_isSavingTournament) {
      return;
    }

    _isSavingTournament = true;
    try {
      await _tournamentHistoryService.saveTournament(record);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to save tournament progress: $e';
        });
      }
    } finally {
      _isSavingTournament = false;
    }
  }

  BadmintonTournamentModel _buildUpdatedTournamentRecord({
    required BadmintonMatchModel completedMatch,
    required int matchIndex,
  }) {
    final current = _tournamentRecord!;
    if (matchIndex == 0) {
      return current.copyWith(semifinal1: completedMatch);
    }
    if (matchIndex == 1) {
      return current.copyWith(semifinal2: completedMatch);
    }
    return current.copyWith(finalMatch: completedMatch);
  }

  List<BadmintonTeamModel> _finalistsFromSemifinals() {
    final semifinal1 = _tournamentRecord?.semifinal1;
    final semifinal2 = _tournamentRecord?.semifinal2;

    return <BadmintonTeamModel>[
      _winnerTeamForMatch(_semifinals[0], semifinal1),
      _winnerTeamForMatch(_semifinals[1], semifinal2),
    ];
  }

  BadmintonTeamModel _winnerTeamForMatch(
    _BracketMatch bracketMatch,
    BadmintonMatchModel? completedMatch,
  ) {
    final winnerName = completedMatch?.finalWinner ?? '';
    if (winnerName == bracketMatch.teamA.teamName) {
      return bracketMatch.teamA;
    }
    if (winnerName == bracketMatch.teamB.teamName) {
      return bracketMatch.teamB;
    }
    return bracketMatch.teamA;
  }

  String _activeMatchTitle() {
    switch (_activeMatchIndex) {
      case 0:
        return 'Semifinal 1';
      case 1:
        return 'Semifinal 2';
      case 2:
        return 'Final Match';
      default:
        return 'Match';
    }
  }

  String _semifinalWinnerName(int index) {
    if (index == 0) {
      return _tournamentRecord?.semifinal1?.finalWinner ?? '';
    }
    return _tournamentRecord?.semifinal2?.finalWinner ?? '';
  }

  String _finalWinnerName() {
    return _tournamentRecord?.finalMatch?.finalWinner ?? '';
  }

  String _finalTeamsLabel(bool isTeamA) {
    final semifinal1 = _tournamentRecord?.semifinal1;
    final semifinal2 = _tournamentRecord?.semifinal2;

    if (semifinal1 == null || semifinal2 == null) {
      return 'Pending';
    }

    final teamA = _winnerTeamForMatch(_semifinals[0], semifinal1);
    final teamB = _winnerTeamForMatch(_semifinals[1], semifinal2);

    return isTeamA ? teamA.teamName : teamB.teamName;
  }

  BadmintonMatchModel _buildInitialMatch({
    required String userId,
    required BadmintonTeamModel teamA,
    required BadmintonTeamModel teamB,
  }) {
    return BadmintonMatchModel(
      matchId: '',
      userId: userId,
      matchType: 'Doubles',
      selectedPoints: 21,
      teamAName: teamA.teamName,
      teamBName: teamB.teamName,
      players: <String, List<String>>{
        'teamA': teamA.players,
        'teamB': teamB.players,
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

  BadmintonTeamModel? _selectedTeamFromTeams(
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

  void _goToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/badminton/create');
        return;
      case 1:
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

class _BracketMatch {
  const _BracketMatch({
    required this.label,
    required this.teamA,
    required this.teamB,
  });

  final String label;
  final BadmintonTeamModel teamA;
  final BadmintonTeamModel teamB;
}

class _TournamentMatchView extends StatefulWidget {
  const _TournamentMatchView({
    required this.match,
    required this.title,
    required this.onMatchCompleted,
  });

  final BadmintonMatchModel match;
  final String title;
  final ValueChanged<BadmintonMatchModel> onMatchCompleted;

  @override
  State<_TournamentMatchView> createState() => _TournamentMatchViewState();
}

class _TournamentMatchViewState extends State<_TournamentMatchView> {
  final BadmintonHistoryService _service = BadmintonHistoryService(
    FirebaseFirestore.instance,
  );

  BadmintonMatchModel? _match;
  String? _lastCountedTieSignature;
  bool _isRoundProcessing = false;
  bool _isMatchFinished = false;
  bool _isSnackbarShowing = false;
  bool _isSavingMatch = false;

  @override
  void initState() {
    super.initState();
    _match = widget.match;
    _syncRuntimeState(widget.match);
  }

  @override
  void didUpdateWidget(covariant _TournamentMatchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.match.matchId != widget.match.matchId) {
      _match = widget.match;
      _syncRuntimeState(widget.match);
    }
  }

  void _syncRuntimeState(BadmintonMatchModel match) {
    final isCompleted =
        match.matchStatus == 'completed' || match.finalWinner.isNotEmpty;
    _isMatchFinished = isCompleted;
    _isRoundProcessing = false;
    _isSnackbarShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    final match = _match;
    if (match == null) {
      return const SizedBox.shrink();
    }

    final isMatchEnded = _isMatchFinished || match.matchStatus == 'completed';

    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Current Round: ${match.currentRound}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildScoreCard(match, true)),
                const SizedBox(width: 12),
                Expanded(child: _buildScoreCard(match, false)),
              ],
            ),
            const SizedBox(height: 16),
            _buildControlCard(match),
            if (match.roundSummaries.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Round History',
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...match.roundSummaries.map(_buildRoundItem),
            ],
            if (isMatchEnded) ...[
              const SizedBox(height: 20),
              _buildMatchEndCard(match),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(BadmintonMatchModel match, bool isTeamA) {
    final canInteract = _canInteractWithScores;
    final label = isTeamA
        ? (match.teamAName.isNotEmpty ? match.teamAName : 'Team A')
        : (match.teamBName.isNotEmpty ? match.teamBName : 'Team B');
    final score = isTeamA ? match.teamAScore : match.teamBScore;

    return Card(
      color: Colors.white.withValues(alpha: 0.03),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              '$score',
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _scoreButton(
                  icon: Icons.add,
                  onTap: canInteract
                      ? () => _adjustScore(isTeamA: isTeamA, delta: 1)
                      : null,
                ),
                const SizedBox(width: 10),
                _scoreButton(
                  icon: Icons.remove,
                  onTap: canInteract && score > 0
                      ? () => _adjustScore(isTeamA: isTeamA, delta: -1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: onTap == null ? Colors.white12 : AppTheme.primaryBlue,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildControlCard(BadmintonMatchModel match) {
    return Card(
      color: Colors.white.withValues(alpha: 0.03),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Match Controls',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Deuce count: ${match.deuceTieCount} | Sudden death: ${match.suddenDeathActive ? 'On' : 'Off'}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchEndCard(BadmintonMatchModel match) {
    final winner = match.finalWinner.isNotEmpty ? match.finalWinner : 'Unknown';
    return Card(
      color: Colors.white.withValues(alpha: 0.03),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Match Winner',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              winner,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundItem(BadmintonRoundSummary summary) {
    return Card(
      color: Colors.white.withValues(alpha: 0.03),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Round ${summary.roundNumber}', style: const TextStyle(color: Colors.white)),
            Text(
              '${summary.teamAScore} - ${summary.teamBScore}',
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(summary.winner, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  bool get _canInteractWithScores {
    final match = _match;
    return match != null &&
        !_isMatchFinished &&
        !_isRoundProcessing &&
        !_isSnackbarShowing;
  }

  Future<void> _adjustScore({required bool isTeamA, required int delta}) async {
    if (!_canInteractWithScores) {
      return;
    }

    final match = _match;
    if (match == null) {
      return;
    }

    _isRoundProcessing = true;
    final nextScores = <String, int>{
      'teamA': match.teamAScore,
      'teamB': match.teamBScore,
    };
    final key = isTeamA ? 'teamA' : 'teamB';
    nextScores[key] = (nextScores[key] ?? 0) + delta;
    if (nextScores[key]! < 0) {
      nextScores[key] = 0;
    }

    final evaluation = _evaluateRoundState(match.copyWith(scores: nextScores));

    if (!mounted) {
      _isRoundProcessing = false;
      return;
    }

    if (!evaluation.roundWon) {
      setState(() {
        _match = evaluation.match;
      });
      await _saveMatchSafely(evaluation.match);
      if (!mounted) {
        _isRoundProcessing = false;
        return;
      }
      setState(() {
        _isRoundProcessing = false;
      });
      return;
    }

    await _handleRoundWin(evaluation);
  }

  _RoundEvaluation _evaluateRoundState(BadmintonMatchModel match) {
    final teamA = match.teamAScore;
    final teamB = match.teamBScore;
    final target = match.selectedPoints;
    var deuceTieCount = match.deuceTieCount;
    var suddenDeathActive = match.suddenDeathActive;

    final isTiedAtDeuceOrBeyond = teamA == teamB && teamA >= target - 1;
    if (isTiedAtDeuceOrBeyond) {
      final tieSignature = '$teamA-$teamB';
      if (_lastCountedTieSignature != tieSignature) {
        deuceTieCount += 1;
        _lastCountedTieSignature = tieSignature;
      }
      if (deuceTieCount >= 3) {
        suddenDeathActive = true;
      }
    } else {
      _lastCountedTieSignature = null;
    }

    final diff = (teamA - teamB).abs();
    final hasRoundWinner = suddenDeathActive
        ? teamA != teamB && (teamA >= target || teamB >= target)
        : (teamA >= target || teamB >= target) && diff >= 2;

    final matchWithState = match.copyWith(
      deuceTieCount: deuceTieCount,
      suddenDeathActive: suddenDeathActive,
    );

    if (!hasRoundWinner) {
      return _RoundEvaluation(
        match: matchWithState,
        roundWon: false,
        matchIsOver: false,
      );
    }

    final winnerKey = teamA > teamB ? 'teamA' : 'teamB';
    final winnerLabel = _teamLabel(matchWithState, winnerKey);

    return _RoundEvaluation(
      match: matchWithState,
      roundWon: true,
      matchIsOver: (winnerKey == 'teamA'
              ? matchWithState.roundsWonA
              : matchWithState.roundsWonB) +
          1 >=
          2,
      winnerKey: winnerKey,
      winnerLabel: winnerLabel,
      suddenDeathUsed: suddenDeathActive,
    );
  }

  Future<void> _handleRoundWin(_RoundEvaluation evaluation) async {
    final match = evaluation.match;
    final winnerKey = evaluation.winnerKey;
    final winnerLabel = evaluation.winnerLabel;

    if (winnerKey == null || winnerLabel == null) {
      _isRoundProcessing = false;
      return;
    }

    if (!mounted) {
      _isRoundProcessing = false;
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    _isSnackbarShowing = true;
    final controller = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          evaluation.matchIsOver
              ? '$winnerLabel wins the match!'
              : '$winnerLabel wins Round ${match.currentRound}',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await controller.closed;
    if (!mounted) {
      _isSnackbarShowing = false;
      _isRoundProcessing = false;
      return;
    }

    final updatedMatch = evaluation.matchIsOver
        ? _buildCompletedMatch(match, winnerKey, winnerLabel, evaluation.suddenDeathUsed)
        : _buildNextRoundMatch(match, winnerKey, winnerLabel, evaluation.suddenDeathUsed);

    setState(() {
      _match = updatedMatch;
      _isMatchFinished = evaluation.matchIsOver;
      _isSnackbarShowing = false;
    });

    await _saveMatchSafely(updatedMatch);

    if (!mounted) {
      _isRoundProcessing = false;
      return;
    }

    if (evaluation.matchIsOver) {
      widget.onMatchCompleted(updatedMatch);
    }

    setState(() {
      _isRoundProcessing = false;
    });
  }

  BadmintonMatchModel _buildNextRoundMatch(
    BadmintonMatchModel match,
    String winnerKey,
    String winnerLabel,
    bool suddenDeathUsed,
  ) {
    final roundSummary = BadmintonRoundSummary(
      roundNumber: match.currentRound,
      teamAScore: match.teamAScore,
      teamBScore: match.teamBScore,
      winner: winnerLabel,
      suddenDeathUsed: suddenDeathUsed,
      completedAt: DateTime.now(),
    );

    final updatedRoundSummaries = <BadmintonRoundSummary>[
      ...match.roundSummaries,
      roundSummary,
    ];
    final updatedRoundsWon = <String, int>{
      'teamA': match.roundsWonA,
      'teamB': match.roundsWonB,
    };
    updatedRoundsWon[winnerKey] = (updatedRoundsWon[winnerKey] ?? 0) + 1;

    return match.copyWith(
      scores: <String, int>{'teamA': 0, 'teamB': 0},
      roundsWon: updatedRoundsWon,
      finalWinner: '',
      matchStatus: 'live',
      currentRound: match.currentRound + 1,
      deuceTieCount: 0,
      suddenDeathActive: false,
      roundSummaries: updatedRoundSummaries,
    );
  }

  BadmintonMatchModel _buildCompletedMatch(
    BadmintonMatchModel match,
    String winnerKey,
    String winnerLabel,
    bool suddenDeathUsed,
  ) {
    final roundSummary = BadmintonRoundSummary(
      roundNumber: match.currentRound,
      teamAScore: match.teamAScore,
      teamBScore: match.teamBScore,
      winner: winnerLabel,
      suddenDeathUsed: suddenDeathUsed,
      completedAt: DateTime.now(),
    );

    final updatedRoundSummaries = <BadmintonRoundSummary>[
      ...match.roundSummaries,
      roundSummary,
    ];
    final updatedRoundsWon = <String, int>{
      'teamA': match.roundsWonA,
      'teamB': match.roundsWonB,
    };
    updatedRoundsWon[winnerKey] = (updatedRoundsWon[winnerKey] ?? 0) + 1;

    return match.copyWith(
      roundsWon: updatedRoundsWon,
      finalWinner: winnerLabel,
      matchStatus: 'completed',
      deuceTieCount: 0,
      suddenDeathActive: false,
      roundSummaries: updatedRoundSummaries,
    );
  }

  Future<void> _saveMatchSafely(BadmintonMatchModel match) async {
    if (_isSavingMatch) {
      return;
    }

    _isSavingMatch = true;
    try {
      await _service.saveMatch(match);
    } catch (e) {
      debugPrint('Failed to save tournament badminton match: $e');
    } finally {
      _isSavingMatch = false;
    }
  }

  String _teamLabel(BadmintonMatchModel match, String key) {
    final isTeamA = key == 'teamA';
    final fallback = isTeamA ? 'Team A' : 'Team B';
    final name = isTeamA ? match.teamAName : match.teamBName;
    return name.isNotEmpty ? name : fallback;
  }
}

class _RoundEvaluation {
  const _RoundEvaluation({
    required this.match,
    required this.roundWon,
    required this.matchIsOver,
    this.winnerKey,
    this.winnerLabel,
    this.suddenDeathUsed = false,
  });

  final BadmintonMatchModel match;
  final bool roundWon;
  final bool matchIsOver;
  final String? winnerKey;
  final String? winnerLabel;
  final bool suddenDeathUsed;
}