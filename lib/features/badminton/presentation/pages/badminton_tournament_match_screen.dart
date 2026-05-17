import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_round_summary.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_tournament_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_tournament_history_service.dart';
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';

class BadmintonTournamentMatchScreen extends StatefulWidget {
  const BadmintonTournamentMatchScreen({super.key, required this.tournament});

  final BadmintonTournamentModel tournament;

  @override
  State<BadmintonTournamentMatchScreen> createState() => _BadmintonTournamentMatchScreenState();
}

class _BadmintonTournamentMatchScreenState extends State<BadmintonTournamentMatchScreen> {
  static const int _currentIndex = 1;

  final BadmintonTournamentHistoryService _service =
      BadmintonTournamentHistoryService(FirebaseFirestore.instance);

  late final List<_BracketMatchState> _bracket;
  late BadmintonTournamentModel _tournament;
  int _activeIndex = 0;
  bool _isProcessing = false;
  bool _isSaving = false;
  bool _championBannerShown = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tournament = widget.tournament;
    final selectedTeams = [...widget.tournament.selectedTeams]..shuffle(Random());
    _bracket = [
      _BracketMatchState(
        label: 'Semifinal 1',
        teamA: selectedTeams[0],
        teamB: selectedTeams[1],
        pointToWin: widget.tournament.pointToWin,
        matchType: widget.tournament.matchType,
      ),
      _BracketMatchState(
        label: 'Semifinal 2',
        teamA: selectedTeams[2],
        teamB: selectedTeams[3],
        pointToWin: widget.tournament.pointToWin,
        matchType: widget.tournament.matchType,
      ),
      _BracketMatchState(
        label: 'Final',
        pointToWin: widget.tournament.pointToWin,
        matchType: widget.tournament.matchType,
      ),
    ];
  }

  _BracketMatchState get _activeMatch => _bracket[_activeIndex];

  BadmintonTeamModel? get _champion {
    if (_tournament.tournamentStatus != 'completed') {
      return null;
    }
    final winnerName = _tournament.tournamentWinner;
    return _tournament.selectedTeams.firstWhere(
      (team) => team.teamName == winnerName,
      orElse: () => _tournament.selectedTeams.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badminton Tournament Match'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/badminton/tournament');
            }
          },
        ),
      ),
      bottomNavigationBar: BadmintonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _goToIndex(context, index),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isWide ? 28 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderCard(tournament: _tournament),
                  const SizedBox(height: 16),
                  _BracketCard(
                    semifinal1: _bracket[0],
                    semifinal2: _bracket[1],
                    finalMatch: _bracket[2],
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
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
                  if (_errorMessage != null) const SizedBox(height: 16),
                  _ActiveMatchCard(
                    match: _activeMatch,
                    isProcessing: _isProcessing,
                    onAddPoint: (isTeamA) => _adjustScore(isTeamA: isTeamA, delta: 1),
                    onUndoPoint: (isTeamA) => _adjustScore(isTeamA: isTeamA, delta: -1),
                  ),
                  const SizedBox(height: 16),
                  _RoundHistoryCard(match: _activeMatch),
                  if (_champion != null) ...[
                    const SizedBox(height: 16),
                    _ChampionBanner(champion: _champion!),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _champion != null
                              ? () => context.go('/badminton/history?tab=tournament')
                              : null,
                          icon: const Icon(Icons.history),
                          label: const Text('View History'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/sport-selection'),
                          icon: const Icon(Icons.home),
                          label: const Text('Back to Dashboard'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _adjustScore({required bool isTeamA, required int delta}) async {
    if (_isProcessing) {
      return;
    }

    final match = _activeMatch;
    if (match.isMatchComplete) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
      match.adjustScore(isTeamA: isTeamA, delta: delta);
    });

    try {
      final result = match.evaluate();
      if (!result.roundComplete) {
        await _saveTournamentProgress();
        return;
      }

      await _completeCurrentMatch(result);
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Unable to update tournament match: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _completeCurrentMatch(_GameResult result) async {
    final match = _activeMatch;
    final winnerTeam = result.winnerKey == 'teamA' ? match.teamA! : match.teamB!;

    match.completeRound(
      winnerLabel: winnerTeam.teamName,
      winnerKey: result.winnerKey!,
      suddenDeathUsed: result.suddenDeathUsed,
    );

    if (match.isMatchComplete) {
      match.finishMatch();
    } else {
      match.prepareNextRound();
    }

    _bracket[_activeIndex] = match;
    await _saveTournamentProgress();

    if (!mounted) {
      return;
    }

    setState(() {});

    if (match.isMatchComplete) {
      await _advanceBracket(winnerTeam);
    }
  }

  Future<void> _advanceBracket(BadmintonTeamModel winnerTeam) async {
    if (_activeIndex == 0) {
      _bracket[2].setTeamA(winnerTeam);
      _activeIndex = 1;
      await _saveTournamentProgress();
      if (mounted) setState(() {});
      return;
    }

    if (_activeIndex == 1) {
      _bracket[2].setTeamB(winnerTeam);
      _activeIndex = 2;
      await _saveTournamentProgress();
      if (mounted) setState(() {});
      return;
    }

    _tournament = _tournament.copyWith(
      semifinal1: _bracket[0].toMatchModel(userId: _tournament.userId),
      semifinal2: _bracket[1].toMatchModel(userId: _tournament.userId),
      finalMatch: _bracket[2].toMatchModel(userId: _tournament.userId),
      tournamentWinner: winnerTeam.teamName,
      tournamentStatus: 'completed',
    );
    await _service.saveTournament(_tournament);

    if (!mounted) {
      return;
    }

    setState(() {});
    if (!_championBannerShown) {
      _championBannerShown = true;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Tournament Champion'),
            content: Text('${winnerTeam.teamName} wins the tournament!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _saveTournamentProgress() async {
    if (_isSaving) {
      return;
    }
    _isSaving = true;
    try {
      _tournament = _tournament.copyWith(
        semifinal1: _bracket[0].toMatchModel(userId: _tournament.userId),
        semifinal2: _bracket[1].toMatchModel(userId: _tournament.userId),
        finalMatch: _bracket[2].toMatchModel(userId: _tournament.userId),
        tournamentWinner: _tournament.tournamentWinner,
        tournamentStatus: _tournament.tournamentStatus,
      );
      await _service.saveTournament(_tournament);
    } finally {
      _isSaving = false;
    }
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.tournament});

  final BadmintonTournamentModel tournament;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryBlue.withValues(alpha: 0.14),
              ),
              child: const Icon(Icons.emoji_events, color: AppTheme.primaryBlue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tournament in Progress',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tournament.matchType} • First to ${tournament.pointToWin} points • Best of 3',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BracketCard extends StatelessWidget {
  const _BracketCard({
    required this.semifinal1,
    required this.semifinal2,
    required this.finalMatch,
  });

  final _BracketMatchState semifinal1;
  final _BracketMatchState semifinal2;
  final _BracketMatchState finalMatch;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tournament Bracket',
              style: TextStyle(color: AppTheme.primaryBlue, fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _BracketMatchRow(match: semifinal1),
            const SizedBox(height: 10),
            _BracketConnector(),
            const SizedBox(height: 10),
            _BracketMatchRow(match: semifinal2),
            const SizedBox(height: 10),
            _BracketConnector(),
            const SizedBox(height: 10),
            _BracketMatchRow(match: finalMatch, isFinal: true),
          ],
        ),
      ),
    );
  }
}

class _BracketMatchRow extends StatelessWidget {
  const _BracketMatchRow({required this.match, this.isFinal = false});

  final _BracketMatchState match;
  final bool isFinal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              match.teamA?.teamName ?? 'Pending',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Text('vs', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              match.teamB?.teamName ?? 'Pending',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isFinal ? 'Final' : match.label,
            style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _BracketConnector extends StatelessWidget {
  const _BracketConnector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 2, color: Colors.white.withValues(alpha: 0.08))),
        Container(width: 2, height: 18, color: Colors.white.withValues(alpha: 0.08)),
        Expanded(child: Container(height: 2, color: Colors.white.withValues(alpha: 0.08))),
      ],
    );
  }
}

class _ActiveMatchCard extends StatelessWidget {
  const _ActiveMatchCard({
    required this.match,
    required this.isProcessing,
    required this.onAddPoint,
    required this.onUndoPoint,
  });

  final _BracketMatchState match;
  final bool isProcessing;
  final ValueChanged<bool> onAddPoint;
  final ValueChanged<bool> onUndoPoint;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              match.label,
              style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Round ${match.currentRound} • First to ${match.pointToWin} points • Best of 3',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ScorePanel(
                    match: match,
                    isTeamA: true,
                    onAddPoint: onAddPoint,
                    onUndoPoint: onUndoPoint,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ScorePanel(
                    match: match,
                    isTeamA: false,
                    onAddPoint: onAddPoint,
                    onUndoPoint: onUndoPoint,
                  ),
                ),
              ],
            ),
            if (isProcessing) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(minHeight: 3),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScorePanel extends StatelessWidget {
  const _ScorePanel({
    required this.match,
    required this.isTeamA,
    required this.onAddPoint,
    required this.onUndoPoint,
  });

  final _BracketMatchState match;
  final bool isTeamA;
  final ValueChanged<bool> onAddPoint;
  final ValueChanged<bool> onUndoPoint;

  @override
  Widget build(BuildContext context) {
    final label = isTeamA ? match.teamA?.teamName ?? 'Team A' : match.teamB?.teamName ?? 'Team B';
    final score = isTeamA ? match.teamAScore : match.teamBScore;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(
            '$score',
            style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 54, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundButton(icon: Icons.add, onTap: () => onAddPoint(isTeamA)),
              const SizedBox(width: 10),
              _RoundButton(
                icon: Icons.remove,
                onTap: score > 0 ? () => onUndoPoint(isTeamA) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
}

class _RoundHistoryCard extends StatelessWidget {
  const _RoundHistoryCard({required this.match});

  final _BracketMatchState match;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Round History',
              style: TextStyle(color: AppTheme.primaryBlue, fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (match.roundSummaries.isEmpty)
              const Text(
                'No completed games yet.',
                style: TextStyle(color: Colors.white70),
              )
            else
              ...match.roundSummaries.map(
                (summary) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Game ${summary.roundNumber}', style: const TextStyle(color: Colors.white)),
                      Text(
                        '${summary.teamAScore} - ${summary.teamBScore}',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(summary.winner, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChampionBanner extends StatelessWidget {
  const _ChampionBanner({required this.champion});

  final BadmintonTeamModel champion;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.emoji_events, color: AppTheme.primaryBlue, size: 56),
            const SizedBox(height: 12),
            const Text(
              'Tournament Champion',
              style: TextStyle(color: AppTheme.primaryBlue, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              champion.teamName,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

class _BracketMatchState {
  _BracketMatchState({
    required this.label,
    required this.pointToWin,
    required this.matchType,
    this.teamA,
    this.teamB,
  }) {
    _syncModel();
  }

  final String label;
  final int pointToWin;
  final String matchType;
  BadmintonTeamModel? teamA;
  BadmintonTeamModel? teamB;

  int _teamAScore = 0;
  int _teamBScore = 0;
  int _currentRound = 1;
  int _roundsWonA = 0;
  int _roundsWonB = 0;
  int _deuceTieCount = 0;
  bool _suddenDeathActive = false;
  bool _isCompleted = false;
  int _lastCompletedTeamAScore = 0;
  int _lastCompletedTeamBScore = 0;
  String _finalWinner = '';
  final List<BadmintonRoundSummary> roundSummaries = <BadmintonRoundSummary>[];
  late BadmintonMatchModel _model;

  int get teamAScore => _teamAScore;
  int get teamBScore => _teamBScore;
  int get currentRound => _currentRound;
  bool get isMatchComplete => _isCompleted;
  BadmintonMatchModel get model => _model;

  void setTeamA(BadmintonTeamModel team) {
    teamA = team;
    _syncModel();
  }

  void setTeamB(BadmintonTeamModel team) {
    teamB = team;
    _syncModel();
  }

  void adjustScore({required bool isTeamA, required int delta}) {
    if (isTeamA) {
      _teamAScore = max(0, _teamAScore + delta);
    } else {
      _teamBScore = max(0, _teamBScore + delta);
    }
    _syncModel();
  }

  _GameResult evaluate() {
    final maxScore = max(_teamAScore, _teamBScore);
    final diff = (_teamAScore - _teamBScore).abs();

    final tiedAtDeuce = _teamAScore == _teamBScore && _teamAScore >= pointToWin - 1;
    if (tiedAtDeuce) {
      _deuceTieCount += 1;
      if (_deuceTieCount >= 3) {
        _suddenDeathActive = true;
      }
    } else if (_teamAScore != _teamBScore) {
      _deuceTieCount = 0;
    }

    final hasWinner = _suddenDeathActive
        ? maxScore >= pointToWin && diff >= 1
        : maxScore >= pointToWin && diff >= 2;

    if (!hasWinner) {
      return const _GameResult(
        roundComplete: false,
        winnerKey: null,
        suddenDeathUsed: false,
      );
    }

    return _GameResult(
      roundComplete: true,
      winnerKey: _teamAScore > _teamBScore ? 'teamA' : 'teamB',
      suddenDeathUsed: _suddenDeathActive,
    );
  }

  void completeRound({
    required String winnerLabel,
    required String winnerKey,
    required bool suddenDeathUsed,
  }) {
    _lastCompletedTeamAScore = _teamAScore;
    _lastCompletedTeamBScore = _teamBScore;
    roundSummaries.add(
      BadmintonRoundSummary(
        roundNumber: _currentRound,
        teamAScore: _teamAScore,
        teamBScore: _teamBScore,
        winner: winnerLabel,
        suddenDeathUsed: suddenDeathUsed,
        completedAt: DateTime.now(),
      ),
    );

    if (winnerKey == 'teamA') {
      _roundsWonA += 1;
    } else {
      _roundsWonB += 1;
    }

    if (_roundsWonA >= 2 || _roundsWonB >= 2) {
      _isCompleted = true;
      _finalWinner = _roundsWonA > _roundsWonB
          ? (teamA?.teamName ?? '')
          : (teamB?.teamName ?? '');
    }

    _syncModel();
  }

  void prepareNextRound() {
    _teamAScore = 0;
    _teamBScore = 0;
    _currentRound += 1;
    _suddenDeathActive = false;
    _deuceTieCount = 0;
    _syncModel();
  }

  void finishMatch() {
    _isCompleted = true;
    _syncModel();
  }

  void _syncModel() {
    _model = BadmintonMatchModel(
      matchId: '',
      userId: '',
      matchType: matchType,
      selectedPoints: pointToWin,
      teamAName: teamA?.teamName ?? '',
      teamBName: teamB?.teamName ?? '',
      players: <String, List<String>>{
        'teamA': teamA?.players ?? <String>[],
        'teamB': teamB?.players ?? <String>[],
      },
      scores: <String, int>{'teamA': _lastCompletedTeamAScore, 'teamB': _lastCompletedTeamBScore},
      roundsWon: <String, int>{'teamA': _roundsWonA, 'teamB': _roundsWonB},
      finalWinner: _finalWinner,
      createdAt: DateTime.now(),
      matchStatus: _isCompleted ? 'completed' : 'live',
      currentRound: _currentRound,
      deuceTieCount: _deuceTieCount,
      suddenDeathActive: _suddenDeathActive,
      roundSummaries: roundSummaries,
    );
  }

  BadmintonMatchModel toMatchModel({required String userId}) {
    return _model.copyWith(
      userId: userId,
      finalWinner: _finalWinner,
      matchStatus: _isCompleted ? 'completed' : 'live',
      scores: <String, int>{'teamA': _lastCompletedTeamAScore, 'teamB': _lastCompletedTeamBScore},
      roundsWon: <String, int>{'teamA': _roundsWonA, 'teamB': _roundsWonB},
      currentRound: _currentRound,
      deuceTieCount: _deuceTieCount,
      suddenDeathActive: _suddenDeathActive,
      roundSummaries: roundSummaries,
    );
  }
}

class _GameResult {
  const _GameResult({
    required this.roundComplete,
    required this.winnerKey,
    required this.suddenDeathUsed,
  });

  final bool roundComplete;
  final String? winnerKey;
  final bool suddenDeathUsed;
}
