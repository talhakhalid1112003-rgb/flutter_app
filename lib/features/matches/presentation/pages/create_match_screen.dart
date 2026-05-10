import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scoring_app/features/teams/presentation/providers/team_providers.dart';
import 'package:scoring_app/features/tournaments/presentation/providers/tournament_providers.dart';
import 'package:scoring_app/core/providers/firebase_providers.dart';
import 'package:scoring_app/features/matches/presentation/providers/match_providers.dart';
import 'package:scoring_app/features/matches/domain/entities/app_match.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_innings.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

class CreateMatchScreen extends ConsumerStatefulWidget {
  final String? tournamentId;
  final String? sportId;
  final String? teamFormat;

  const CreateMatchScreen({super.key, this.tournamentId, this.sportId, this.teamFormat});

  @override
  ConsumerState<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends ConsumerState<CreateMatchScreen> {
  final teamACtrl = TextEditingController();
  final teamBCtrl = TextEditingController();
  String? teamAId;
  String? teamBId;
  final oversCtrl = TextEditingController(text: '20');
  int selectedSets = 20; // For badminton
  String? tossWinner; // 'host' or 'visitor'
  String tossDecision = 'Bat';

  @override
  void dispose() {
    teamACtrl.dispose();
    teamBCtrl.dispose();
    oversCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSport = widget.sportId?.toUpperCase() ?? 'CRICKET';

    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedSport Scorer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppTheme.cardColorDark,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected sport: ${selectedSport.toLowerCase()}',
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.sportId == 'badminton' && widget.teamFormat != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Format: ${widget.teamFormat!.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamSelectionCard(),
            const SizedBox(height: 24),
            if (widget.sportId != 'badminton') ...[const Text(
              'Toss won by?',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildTossWinnerSelection(),
            const SizedBox(height: 24),
            const Text(
              'Opted to?',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDecisionSelection(),
            const SizedBox(height: 24),],
            if (widget.sportId == 'badminton') ...[const Text(
              'Points to Win:',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [11, 15, 21].map((value) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedSets = value),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedSets == value
                            ? AppTheme.primaryBlue.withAlpha(51)
                            : Colors.transparent,
                        border: Border.all(
                          color: selectedSets == value ? AppTheme.primaryBlue : Colors.white24,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selectedSets == value
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: selectedSets == value ? AppTheme.primaryBlue : Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$value',
                            style: TextStyle(
                              color: selectedSets == value ? AppTheme.primaryBlue : Colors.white,
                              fontWeight: selectedSets == value ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),] else ...[TextField(
              controller: oversCtrl,
              decoration: const InputDecoration(labelText: 'Overs'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startMatch,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Start match'),
            ),
          ],
       ] ),
      ),
    );
  }

  Widget _buildTeamSelectionCard() {
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Enter or Select Team Names',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: teamACtrl,
              decoration: InputDecoration(
                labelText: 'Host Team Name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.list, color: AppTheme.primaryBlue),
                  onPressed: () => _showTeamSelectionModal(true),
                ),
              ),
              onChanged: (val) {
                teamAId = null;
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'VS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: teamBCtrl,
              decoration: InputDecoration(
                labelText: 'Visitor Team Name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.list, color: AppTheme.primaryBlue),
                  onPressed: () => _showTeamSelectionModal(false),
                ),
              ),
              onChanged: (val) {
                teamBId = null;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTeamSelectionModal(bool isHost) async {
    try {
      final sportId = widget.sportId ?? 'cricket';
      final allTeams = await ref.read(teamsProvider(sportId).future);
      List<dynamic> teamsToShow = allTeams;

      if (widget.tournamentId != null) {
        final tournament = await ref.read(
          tournamentDetailsProvider(widget.tournamentId!).future,
        );
        if (tournament != null) {
          teamsToShow = allTeams
              .where((t) => tournament.teamIds.contains(t.teamId))
              .toList();
        }
      }

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.cardColorDark,
        builder: (ctx) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.sportId == 'badminton' && widget.teamFormat != null
                      ? 'Select ${widget.teamFormat} ${isHost ? "Host" : "Visitor"} Team'
                      : 'Select ${isHost ? "Host" : "Visitor"} Team',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: teamsToShow.length,
                  itemBuilder: (context, index) {
                    final t = teamsToShow[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppTheme.primaryBlue,
                        child: Icon(Icons.group, color: Colors.white),
                      ),
                      title: Text(
                        t.teamName,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          if (isHost) {
                            teamACtrl.text = t.teamName;
                            teamAId = t.teamId;
                          } else {
                            teamBCtrl.text = t.teamName;
                            teamBId = t.teamId;
                          }
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading teams: $e')));
      }
    }
  }

  Widget _buildTossWinnerSelection() {
    final hostName = teamACtrl.text.trim().isNotEmpty
        ? teamACtrl.text.trim()
        : "Host Team";
    final visitorName = teamBCtrl.text.trim().isNotEmpty
        ? teamBCtrl.text.trim()
        : "Visitor Team";
    return Row(
      children: [
        Expanded(
          child: _buildCustomSelection(
            label: 'Host ($hostName)',
            isSelected: tossWinner == 'host',
            onTap: () => setState(() => tossWinner = 'host'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCustomSelection(
            label: 'Visitor ($visitorName)',
            isSelected: tossWinner == 'visitor',
            onTap: () => setState(() => tossWinner = 'visitor'),
          ),
        ),
      ],
    );
  }

  Widget _buildDecisionSelection() {
    return Row(
      children: [
        Expanded(
          child: _buildCustomSelection(
            label: 'Bat',
            isSelected: tossDecision == 'Bat',
            onTap: () => setState(() => tossDecision = 'Bat'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCustomSelection(
            label: 'Bowl',
            isSelected: tossDecision == 'Bowl',
            onTap: () => setState(() => tossDecision = 'Bowl'),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSelection({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withAlpha(51)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.white24,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.primaryBlue : Colors.white54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryBlue : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startMatch() async {
    final teamAName = teamACtrl.text.trim();
    final teamBName = teamBCtrl.text.trim();
    
    // Badminton doesn't need toss winner
    final isBadminton = widget.sportId == 'badminton';
    if (teamAName.isEmpty || teamBName.isEmpty || (!isBadminton && tossWinner == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isBadminton ? 'Please enter team names' : 'Please enter team names and select toss winner'),
        ),
      );
      return;
    }
    
    // Set defaults for badminton
    if (isBadminton) {
      tossWinner ??= 'host';
      tossDecision = 'Bat';
    }
    
    int overs = isBadminton ? selectedSets : (int.tryParse(oversCtrl.text) ?? 20);

    final matchId = const Uuid().v4();
    final finalTeamAId = teamAId ?? const Uuid().v4();
    final finalTeamBId = teamBId ?? const Uuid().v4();

    final actualTossWinnerName = tossWinner == 'host' ? teamAName : teamBName;

    final match = AppMatch(
      matchId: matchId,
      teamAName: teamAName,
      teamBName: teamBName,
      teamAId: finalTeamAId,
      teamBId: finalTeamBId,
      tournamentId: widget.tournamentId,
      overs: overs,
      tossWinner: actualTossWinnerName,
      tossDecision: tossDecision.toLowerCase(),
      matchStatus: 'live',
      currentPhase: MatchPhase.firstInnings,
      createdAt: DateTime.now(),
    );

    String battingTeamName = tossDecision.toLowerCase() == 'bat'
        ? actualTossWinnerName
        : (tossWinner == 'host' ? teamBName : teamAName);
    String bowlingTeamName = battingTeamName == teamAName
        ? teamBName
        : teamAName;

    String battingTeamId = battingTeamName == teamAName
        ? finalTeamAId
        : finalTeamBId;
    String bowlingTeamId = battingTeamName == teamAName
        ? finalTeamBId
        : finalTeamAId;

    final inningsId = const Uuid().v4();
    final innings = AppInnings(
      inningsId: inningsId,
      matchId: matchId,
      battingTeamName: battingTeamName,
      bowlingTeamName: bowlingTeamName,
      battingTeamId: battingTeamId,
      bowlingTeamId: bowlingTeamId,
      totalRuns: 0,
      wickets: 0,
      overs: 0.0,
    );

    try {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login to create a match.')));
        return;
      }

      await ref.read(matchRepositoryProvider).createMatch(
            match,
            sportId: widget.sportId ?? 'cricket',
            createdBy: userId,
          );
      await ref.read(matchRepositoryProvider).saveInnings(innings);
      if (widget.tournamentId != null) {
        final tournament = await ref.read(
          tournamentDetailsProvider(widget.tournamentId!).future,
        );
        if (tournament != null) {
          await ref
              .read(tournamentRepositoryProvider)
              .updateTournament(
                tournament.copyWith(
                  matchIds: [...tournament.matchIds, matchId],
                ),
              );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        return;
      }
    }

    if (mounted) {
      if (widget.sportId == 'badminton') {
        context.go('/badminton-match-score/$matchId');
      } else {
        context.go('/match-squad/$matchId/$inningsId');
      }
    }
  }
}
