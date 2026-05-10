import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_app/core/config/app_theme.dart';

class BadmintonMatchScoreScreen extends ConsumerStatefulWidget {
  final String matchId;

  const BadmintonMatchScoreScreen({
    super.key,
    required this.matchId,
  });

  @override
  ConsumerState<BadmintonMatchScoreScreen> createState() => _BadmintonMatchScoreScreenState();
}

class _BadmintonMatchScoreScreenState extends ConsumerState<BadmintonMatchScoreScreen> {
  int teamAScore = 0;
  int teamBScore = 0;
  int currentSet = 1;
  int totalSets = 3;
  List<int> teamASetScores = []; // Scores from completed sets
  List<int> teamBSetScores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badminton Match Score'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Set Info
            Card(
              color: AppTheme.cardColorDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Set $currentSet of $totalSets',
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Score Display
            Row(
              children: [
                Expanded(
                  child: _buildScoreCard('Team A', teamAScore, true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildScoreCard('Team B', teamBScore, false),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Score Controls
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Team A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => setState(() => teamAScore++),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('+1 Point'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: teamAScore > 0 ? () => setState(() => teamAScore--) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Undo'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Team B',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => setState(() => teamBScore++),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('+1 Point'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: teamBScore > 0 ? () => setState(() => teamBScore--) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Undo'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // End Set Button
            if (_isSetWon()) ...[
              ElevatedButton(
                onPressed: _endSet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'End Set',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Set History
            if (teamASetScores.isNotEmpty) ...[
              const Text(
                'Set History',
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: List.generate(
                  teamASetScores.length,
                  (index) => Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColorDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Set ${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${teamASetScores[index]} - ${teamBSetScores[index]}',
                          style: const TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildScoreCard(String teamName, int score, bool isTeamA) {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              teamName,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$score',
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSetWon() {
    // Badminton: typically first to 21 (or 11) wins, with 2 point margin
    const pointsToWin = 21;
    const margin = 2;
    return (teamAScore >= pointsToWin || teamBScore >= pointsToWin) &&
        (teamAScore - teamBScore).abs() >= margin;
  }

  void _endSet() {
    setState(() {
      teamASetScores.add(teamAScore);
      teamBSetScores.add(teamBScore);
      teamAScore = 0;
      teamBScore = 0;
      currentSet++;
    });

    // Check if match is over (best of 3 sets typically)
    int teamASetWins = teamASetScores.where((score) => _isSetWinner(true, teamASetScores.indexOf(score))).length;
    int teamBSetWins = teamBSetScores.where((score) => _isSetWinner(false, teamBSetScores.indexOf(score))).length;

    if (teamASetWins == 2 || teamBSetWins == 2) {
      _showMatchEndDialog(teamASetWins > teamBSetWins ? 'Team A' : 'Team B');
    }
  }

  bool _isSetWinner(bool isTeamA, int setIndex) {
    if (setIndex < 0 || setIndex >= teamASetScores.length) return false;
    return isTeamA
        ? teamASetScores[setIndex] > teamBSetScores[setIndex]
        : teamBSetScores[setIndex] > teamASetScores[setIndex];
  }

  void _showMatchEndDialog(String winner) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Match Finished'),
        content: Text('$winner wins the match!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
