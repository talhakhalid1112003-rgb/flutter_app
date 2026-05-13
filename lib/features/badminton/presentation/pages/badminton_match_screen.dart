import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoring_app/features/badminton/presentation/pages/badminton_dashboard_screen.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_round_summary.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_history_service.dart';
import 'package:scoring_app/models/sport_model.dart';

enum MatchState { playing, roundEnding, matchEnded }

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
  MatchState _matchState = MatchState.playing;
  bool _isRoundProcessing = false;
  bool _isMatchFinished = false;
  bool _isSnackbarShowing = false;
  bool _isSavingMatch = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMatch != null) {
      _match = widget.initialMatch;
      _loading = false;
      _syncRuntimeState(widget.initialMatch!);
    } else {
      _loadMatch();
    }
  }

  void _syncRuntimeState(BadmintonMatchModel match) {
    final isCompleted = match.matchStatus == 'completed' ||
        match.finalWinner.isNotEmpty;
    _matchState = isCompleted ? MatchState.matchEnded : MatchState.playing;
    _isMatchFinished = isCompleted;
    _isRoundProcessing = false;
    _isSnackbarShowing = false;
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
        _syncRuntimeState(match);
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
    final isMatchEnded = _isMatchFinished || match.matchStatus == 'completed';
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
            _buildControlCard(match),
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
            if (isMatchEnded) ...[
              const SizedBox(height: 20),
              _buildMatchEndCard(match),
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
    final canInteract = _canInteractWithScores;
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
                  onTap: canInteract
                      ? () => _adjustScore(isTeamA: isTeamA, delta: 1)
                      : null,
                ),
                const SizedBox(width: 12),
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
            const SizedBox(height: 8),
            Text(
              'State: ${_matchState.name}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchEndCard(BadmintonMatchModel match) {
    final winner = match.finalWinner.isNotEmpty ? match.finalWinner : 'Unknown';
    return Card(
      color: AppTheme.cardColorDark,
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
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _goBackToBadmintonHome(match),
              icon: const Icon(Icons.home),
              label: const Text('Back to Badminton Home'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
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

  bool get _canInteractWithScores {
    return _match != null &&
        _error == null &&
        !_loading &&
        !_isMatchFinished &&
        !_isRoundProcessing &&
        !_isSnackbarShowing &&
        _matchState == MatchState.playing;
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
    if (!_canInteractWithScores) {
      return;
    }

    final match = _match;
    if (match == null) {
      return;
    }

    _isRoundProcessing = true;
    if (!mounted) {
      _isRoundProcessing = false;
      return;
    }

    setState(() {
      _matchState = MatchState.roundEnding;
    });

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
        _matchState = MatchState.playing;
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
      matchIsOver: (winnerKey == 'teamA' ? matchWithState.roundsWonA : matchWithState.roundsWonB) + 1 >= 2,
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
    final statusMessage = evaluation.matchIsOver
        ? '$winnerLabel wins the match!'
        : '$winnerLabel wins Round ${match.currentRound}';

    final controller = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(statusMessage),
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
      _matchState = evaluation.matchIsOver
          ? MatchState.matchEnded
          : MatchState.playing;
      _isMatchFinished = evaluation.matchIsOver;
      _isSnackbarShowing = false;
    });

    await _saveMatchSafely(updatedMatch);

    if (!mounted) {
      _isRoundProcessing = false;
      return;
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
      debugPrint('Failed to save badminton match: $e');
    } finally {
      _isSavingMatch = false;
    }
  }

  String _teamLabel(BadmintonMatchModel match, String key) {
    final isTeamA = key == 'teamA';
    if (match.matchType == 'Singles') {
      return isTeamA ? 'Player A' : 'Player B';
    }

    final fallback = isTeamA ? 'Team A' : 'Team B';
    final name = isTeamA ? match.teamAName : match.teamBName;
    return name.isNotEmpty ? name : fallback;
  }

  void _goBackToBadmintonHome(BadmintonMatchModel match) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => BadmintonDashboardScreen(
          sport: SportModel.badminton,
          sportId: 'badminton',
          selectedFormat: match.matchType,
        ),
      ),
      (route) => false,
    );
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
