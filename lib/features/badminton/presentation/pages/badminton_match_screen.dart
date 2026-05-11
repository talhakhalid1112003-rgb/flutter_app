import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_round_summary.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_history_service.dart';

class BadmintonMatchScreen extends StatefulWidget {
  const BadmintonMatchScreen({
    super.key,
    required this.matchId,
    this.initialMatch,
  });

  final String matchId;
  final BadmintonMatchModel? initialMatch;

  @override
  State<BadmintonMatchScreen> createState() => _BadmintonMatchScreenState();
}

class _BadmintonMatchScreenState extends State<BadmintonMatchScreen> {
  final BadmintonHistoryService _service = BadmintonHistoryService(
    FirebaseFirestore.instance,
  );

  BadmintonMatchModel? _match;
  bool _loading = true;
  String? _error;
  String? _lastCountedTieSignature;

  @override
  void initState() {
    super.initState();
    if (widget.initialMatch != null) {
      _match = widget.initialMatch;
      _loading = false;
    } else {
      _loadMatch();
    }
  }

  Future<void> _loadMatch() async {
    try {
      final match = await _service.getMatchById(widget.matchId);
      if (!mounted) {
        return;
      }
      if (match == null) {
        setState(() {
          _error = 'Match not found.';
          _loading = false;
        });
        return;
      }
      setState(() {
        _match = match;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _match == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Badminton Match')),
        body: Center(child: Text(_error ?? 'Unable to load match.')),
      );
    }

    final match = _match!;
    return Scaffold(
      appBar: AppBar(title: const Text('BADMINTON Match')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(match),
            const SizedBox(height: 16),
            _buildRoundSummaryCard(match),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildScoreCard(context, match, true)),
                const SizedBox(width: 16),
                Expanded(child: _buildScoreCard(context, match, false)),
              ],
            ),
            const SizedBox(height: 16),
            if (match.matchStatus != 'completed') _buildControlCard(match),
            if (match.roundSummaries.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Round History',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...match.roundSummaries.map(_buildRoundItem),
            ],
            if (match.matchStatus == 'completed') ...[
              const SizedBox(height: 20),
              Card(
                color: AppTheme.cardColorDark,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${match.finalWinner} wins the match!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BadmintonMatchModel match) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.matchType,
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Round: ${match.currentRound}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              'Target Points: ${match.selectedPoints}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Rounds Won - ${match.teamAName.isNotEmpty ? match.teamAName : 'Team A'}: ${match.roundsWonA} | ${match.teamBName.isNotEmpty ? match.teamBName : 'Team B'}: ${match.roundsWonB}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundSummaryCard(BadmintonMatchModel match) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _roundPill('Team A', match.roundsWonA),
            _roundPill('Team B', match.roundsWonB),
            _roundPill(
              'Status',
              match.matchStatus == 'completed' ? 1 : 0,
              suffix: match.matchStatus,
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundPill(String label, int value, {String? suffix}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        CircleAvatar(
          backgroundColor: AppTheme.primaryBlue,
          child: Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (suffix != null) ...[
          const SizedBox(height: 4),
          Text(
            suffix,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildScoreCard(
    BuildContext context,
    BadmintonMatchModel match,
    bool isTeamA,
  ) {
    final label = isTeamA
        ? (match.matchType == 'Singles'
              ? 'Player A'
              : (match.teamAName.isNotEmpty ? match.teamAName : 'Team A'))
        : (match.matchType == 'Singles'
              ? 'Player B'
              : (match.teamBName.isNotEmpty ? match.teamBName : 'Team B'));
    final score = isTeamA ? match.teamAScore : match.teamBScore;
    return Card(
      color: AppTheme.cardColorDark,
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
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _scoreButton(
                  icon: Icons.add,
                  onTap: match.matchStatus == 'completed'
                      ? null
                      : () => _adjustScore(isTeamA: isTeamA, delta: 1),
                ),
                const SizedBox(width: 12),
                _scoreButton(
                  icon: Icons.remove,
                  onTap: match.matchStatus == 'completed' || score == 0
                      ? null
                      : () => _adjustScore(isTeamA: isTeamA, delta: -1),
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
        width: 48,
        height: 48,
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
      color: AppTheme.cardColorDark,
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

  Widget _buildRoundItem(BadmintonRoundSummary summary) {
    return Card(
      color: AppTheme.cardColorDark,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Round ${summary.roundNumber}',
              style: const TextStyle(color: Colors.white),
            ),
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

  Future<void> _adjustScore({required bool isTeamA, required int delta}) async {
    final match = _match;
    if (match == null || match.matchStatus == 'completed') {
      return;
    }

    final nextScores = <String, int>{
      'teamA': match.teamAScore,
      'teamB': match.teamBScore,
    };
    final key = isTeamA ? 'teamA' : 'teamB';
    nextScores[key] = (nextScores[key] ?? 0) + delta;
    if (nextScores[key]! < 0) {
      nextScores[key] = 0;
    }

    final updatedMatch = _applyGameLogic(match.copyWith(scores: nextScores));
    if (!mounted) {
      return;
    }
    setState(() {
      _match = updatedMatch;
    });
    await _service.saveMatch(updatedMatch);
  }

  BadmintonMatchModel _applyGameLogic(BadmintonMatchModel match) {
    final teamA = match.teamAScore;
    final teamB = match.teamBScore;
    final target = match.selectedPoints;
    var deuceTieCount = match.deuceTieCount;
    var suddenDeathActive = match.suddenDeathActive;
    String? tieSignature;

    final isTiedAtDeuceOrBeyond = teamA == teamB && teamA >= target - 1;
    if (isTiedAtDeuceOrBeyond) {
      tieSignature = '$teamA-$teamB';
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

    if (!hasRoundWinner) {
      return match.copyWith(
        deuceTieCount: deuceTieCount,
        suddenDeathActive: suddenDeathActive,
      );
    }

    final winnerKey = teamA > teamB ? 'teamA' : 'teamB';
    final winnerLabel = winnerKey == 'teamA'
        ? (match.matchType == 'Singles'
              ? 'Player A'
              : (match.teamAName.isNotEmpty ? match.teamAName : 'Team A'))
        : (match.matchType == 'Singles'
              ? 'Player B'
              : (match.teamBName.isNotEmpty ? match.teamBName : 'Team B'));

    final roundSummary = BadmintonRoundSummary(
      roundNumber: match.currentRound,
      teamAScore: teamA,
      teamBScore: teamB,
      winner: winnerLabel,
      suddenDeathUsed: suddenDeathActive,
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

    final matchIsOver = updatedRoundsWon[winnerKey] == 2;
    final finalWinner = matchIsOver ? winnerLabel : '';

    final nextScores = matchIsOver
        ? <String, int>{'teamA': teamA, 'teamB': teamB}
        : <String, int>{'teamA': 0, 'teamB': 0};

    final updatedMatch = match.copyWith(
      scores: nextScores,
      roundsWon: updatedRoundsWon,
      finalWinner: finalWinner,
      matchStatus: matchIsOver ? 'completed' : 'live',
      currentRound: matchIsOver ? match.currentRound : match.currentRound + 1,
      deuceTieCount: 0,
      suddenDeathActive: false,
      roundSummaries: updatedRoundSummaries,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _showTopMessage(
        matchIsOver
            ? '$winnerLabel wins the match!'
            : '$winnerLabel wins Round ${match.currentRound}',
      );
    });

    return updatedMatch;
  }

  void _showTopMessage(String message) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Match update',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColorDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryBlue),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetTween = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        );
        return SlideTransition(
          position: offsetTween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
