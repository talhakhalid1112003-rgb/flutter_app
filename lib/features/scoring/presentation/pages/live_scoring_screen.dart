// ignore_for_file: undefined_getter, undefined_named_parameter, undefined_method

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cricket_scorer/features/scoring/presentation/providers/scoring_controller.dart';
import 'package:smart_cricket_scorer/features/scoring/presentation/providers/scoring_state.dart';
import 'package:smart_cricket_scorer/features/matches/presentation/providers/match_providers.dart';
import 'package:smart_cricket_scorer/features/matches/domain/entities/app_match.dart';
import 'package:smart_cricket_scorer/features/scoring/domain/entities/app_innings.dart';
import 'package:smart_cricket_scorer/features/teams/presentation/providers/player_providers.dart';
import 'package:smart_cricket_scorer/features/scoring/domain/entities/match_player_stats.dart';
import 'package:smart_cricket_scorer/core/config/app_theme.dart';
import 'package:go_router/go_router.dart';

class LiveScoringScreen extends ConsumerStatefulWidget {
  final String matchId;
  final String inningsId;

  const LiveScoringScreen({super.key, required this.matchId, required this.inningsId});

  @override
  ConsumerState<LiveScoringScreen> createState() => _LiveScoringScreenState();
}

class _LiveScoringScreenState extends ConsumerState<LiveScoringScreen> {
  bool _initialized = false;
  bool isWide = false;
  bool isNoBall = false;
  bool isByes = false;
  bool isLegByes = false;
  bool isWicket = false;

  void _checkInitialization(AppMatch match, AppInnings innings) {
    if (_initialized) return;
    final state = ref.read(scoringControllerProvider);
    if (match.currentStrikerId == null || match.currentStrikerId!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInitDialog(match, innings);
      });
    } else if (state == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(scoringControllerProvider.notifier).initialize(
          matchId: widget.matchId,
          inningsId: widget.inningsId,
          strikerId: match.currentStrikerId!,
          strikerName: 'Striker', 
          nonStrikerId: match.currentNonStrikerId ?? 'Non-Striker',
          nonStrikerName: 'Non-Striker',
          bowlerId: match.currentBowlerId ?? 'Bowler',
          bowlerName: 'Bowler',
          targetScore: match.targetScore,
          totalOvers: match.overs,
        );
      });
    }
    _initialized = true;
  }

  void _showInitDialog(AppMatch match, AppInnings innings) async {
    final battingPlayers = await ref.read(playersByTeamProvider(innings.battingTeamId ?? '').future);
    final bowlingPlayers = await ref.read(playersByTeamProvider(innings.bowlingTeamId ?? '').future);
    
    if (!mounted) return;

    String? striker;
    String? nonStriker;
    String? bowler;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
             return AlertDialog(
               backgroundColor: AppTheme.cardColorDark,
               title: const Text('Match Initialization', style: TextStyle(color: Colors.white)),
               content: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   DropdownButtonFormField<String>(
                     decoration: const InputDecoration(labelText: 'Striker'),
                     items: battingPlayers.map((p) => DropdownMenuItem(value: p.playerId, child: Text(p.playerName, style: TextStyle(color: Colors.white)))).toList(),
                     dropdownColor: AppTheme.cardColorDark,
                     onChanged: (v) => setState(() => striker = v),
                   ),
                   const SizedBox(height: 10),
                   DropdownButtonFormField<String>(
                     decoration: const InputDecoration(labelText: 'Non-Striker'),
                     items: battingPlayers.where((p) => p.playerId != striker).map((p) => DropdownMenuItem(value: p.playerId, child: Text(p.playerName, style: TextStyle(color: Colors.white)))).toList(),
                     dropdownColor: AppTheme.cardColorDark,
                     onChanged: (v) => setState(() => nonStriker = v),
                   ),
                   const SizedBox(height: 10),
                   DropdownButtonFormField<String>(
                     decoration: const InputDecoration(labelText: 'Opening Bowler'),
                     items: bowlingPlayers.map((p) => DropdownMenuItem(value: p.playerId, child: Text(p.playerName, style: TextStyle(color: Colors.white)))).toList(),
                     dropdownColor: AppTheme.cardColorDark,
                     onChanged: (v) => setState(() => bowler = v),
                   ),
                 ],
               ),
               actions: [
                 ElevatedButton(
                   onPressed: () {
                     if (striker != null && nonStriker != null && bowler != null) {
                       Navigator.pop(ctx);
                     }
                   },
                   child: const Text('Start Match'),
                 )
               ],
             );
          }
        );
      }
    );

    if (striker != null && nonStriker != null && bowler != null) {
      String stN = battingPlayers.firstWhere((p) => p.playerId == striker).playerName;
      String nstN = battingPlayers.firstWhere((p) => p.playerId == nonStriker).playerName;
      String bwN = bowlingPlayers.firstWhere((p) => p.playerId == bowler).playerName;

      ref.read(scoringControllerProvider.notifier).initialize(
        matchId: widget.matchId,
        inningsId: widget.inningsId,
        strikerId: striker!,
        strikerName: stN,
        nonStrikerId: nonStriker!,
        nonStrikerName: nstN,
        bowlerId: bowler!,
        bowlerName: bwN,
        targetScore: match.targetScore,
        totalOvers: match.overs,
      );
      
      final updatedMatch = match.copyWith(
        currentStrikerId: striker,
        currentNonStrikerId: nonStriker,
        currentBowlerId: bowler,
      );
      
      ref.read(matchRepositoryProvider).createMatch(updatedMatch); 
    }
  }

  Future<void> _showNextBatsmanDialog(String teamId) async {
    if (!mounted) return;
    final players = await ref.read(playersByTeamProvider(teamId).future);
    final state = ref.read(scoringControllerProvider);
    if (state == null || !mounted) return;

    final availablePlayers = players.where((p) => 
      p.playerId != state.strikerId && 
      p.playerId != state.nonStrikerId && 
      !(state.batsmanStats[p.playerId]?.isOut ?? false)
    ).toList();

    if (availablePlayers.isEmpty) return;

    String? selectedPlayer;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
             return AlertDialog(
               backgroundColor: AppTheme.cardColorDark,
               title: const Text('New Batsman', style: TextStyle(color: Colors.white)),
               content: DropdownButtonFormField<String>(
                 decoration: const InputDecoration(labelText: 'Select Batsman'),
                 items: availablePlayers.map((p) => DropdownMenuItem(value: p.playerId, child: Text(p.playerName, style: const TextStyle(color: Colors.white)))).toList(),
                 dropdownColor: AppTheme.cardColorDark,
                 onChanged: (v) => setState(() => selectedPlayer = v),
               ),
               actions: [
                 ElevatedButton(
                   onPressed: () {
                     if (selectedPlayer != null) Navigator.pop(ctx);
                   },
                   child: const Text('OK'),
                 )
               ],
             );
          }
        );
      }
    );

    if (selectedPlayer != null && mounted) {
      final pName = availablePlayers.firstWhere((p) => p.playerId == selectedPlayer).playerName;
      final st = ref.read(scoringControllerProvider)!;
      String newStriker = st.strikerId;
      String newNonStriker = st.nonStrikerId;
      String stName = st.batsmanStats[st.strikerId]?.playerName ?? 'Striker';
      String nstName = st.batsmanStats[st.nonStrikerId]?.playerName ?? 'Non-Striker';

      bool isStrikerOut = st.batsmanStats[st.strikerId]?.isOut ?? false;
      bool isNonStrikerOut = st.batsmanStats[st.nonStrikerId]?.isOut ?? false;

      if (isStrikerOut) {
        newStriker = selectedPlayer!;
        stName = pName;
      } else if (isNonStrikerOut) {
        newNonStriker = selectedPlayer!;
        nstName = pName;
      }

      ref.read(scoringControllerProvider.notifier).updatePlayers(
        newStriker, newNonStriker, st.bowlerId, stName, nstName, st.bowlerStats[st.bowlerId]?.playerName ?? 'Bowler'
      );
    }
  }

  Future<void> _showNextBowlerDialog(String teamId) async {
    if (!mounted) return;
    final players = await ref.read(playersByTeamProvider(teamId).future);
    final state = ref.read(scoringControllerProvider);
    if (state == null || !mounted) return;

    final availablePlayers = players.where((p) => p.playerId != state.bowlerId).toList();
    if (availablePlayers.isEmpty) return;

    String? selectedPlayer;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
             return AlertDialog(
               backgroundColor: AppTheme.cardColorDark,
               title: const Text('Next Bowler', style: TextStyle(color: Colors.white)),
               content: DropdownButtonFormField<String>(
                 decoration: const InputDecoration(labelText: 'Select Bowler'),
                 items: availablePlayers.map((p) => DropdownMenuItem(value: p.playerId, child: Text(p.playerName, style: const TextStyle(color: Colors.white)))).toList(),
                 dropdownColor: AppTheme.cardColorDark,
                 onChanged: (v) => setState(() => selectedPlayer = v),
               ),
               actions: [
                 ElevatedButton(
                   onPressed: () {
                     if (selectedPlayer != null) Navigator.pop(ctx);
                   },
                   child: const Text('OK'),
                 )
               ],
             );
          }
        );
      }
    );

    if (selectedPlayer != null && mounted) {
      final pName = availablePlayers.firstWhere((p) => p.playerId == selectedPlayer).playerName;
      final st = ref.read(scoringControllerProvider)!;
      final stName = st.batsmanStats[st.strikerId]?.playerName ?? 'Striker';
      final nstName = st.batsmanStats[st.nonStrikerId]?.playerName ?? 'Non-Striker';

      ref.read(scoringControllerProvider.notifier).updatePlayers(
        st.strikerId, st.nonStrikerId, selectedPlayer!, stName, nstName, pName
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mtcAsync = ref.watch(matchesProvider);
    final inAsync = ref.watch(inningsProvider(widget.matchId));

    ref.listen<ScoringState?>(scoringControllerProvider, (previous, next) {
      if (previous == null || next == null) return;
      if (next.currentPhase == MatchPhase.completed || next.currentPhase == MatchPhase.inningsBreak) return;

      inAsync.whenData((inningsList) async {
        final matchedIn = inningsList.where((i) => i.inningsId == widget.inningsId).toList();
        if (matchedIn.isEmpty) return;
        final innings = matchedIn.first;

        if (next.wickets > previous.wickets && next.wickets < 10) {
          await _showNextBatsmanDialog(innings.battingTeamId ?? '');
        }

        if (next.completedOvers > previous.completedOvers) {
          await _showNextBowlerDialog(innings.bowlingTeamId ?? '');
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text('Easy Cricket Scorer'),
        actions: [
          IconButton(icon: const Icon(Icons.show_chart, color: AppTheme.primaryBlue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.scoreboard_outlined, color: AppTheme.primaryBlue), onPressed: () {}),
        ],
      ),
      body: mtcAsync.when(
        data: (matches) {
          final matched = matches.where((m) => m.matchId == widget.matchId).toList();
          if (matched.isEmpty) return const Center(child: Text("Match not found"));
          final match = matched.first;
          
          return inAsync.when(
            data: (inningsList) {
               final matchedIn = inningsList.where((i) => i.inningsId == widget.inningsId).toList();
               if (matchedIn.isEmpty) return const Center(child: Text("Innings not found"));
               final innings = matchedIn.first;
               
               _checkInitialization(match, innings);
               
               final state = ref.watch(scoringControllerProvider);
               if (state == null || state.isLoading) {
                 return const Center(child: CircularProgressIndicator());
               }
               
               if (state.currentPhase == MatchPhase.completed) {
                 return Center(
                   child: Text(match.matchResult ?? "Match Complete", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                 );
               }

               return Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     _buildTopHeader(match),
                     _buildScoreBoard(state, match, innings),
                     _buildActivePlayersGrid(state),
                     _buildQuickActionRow(state, match, innings),
                     _buildScorePad(match, innings),
                     _buildBottomActionButtons(match, innings),
                   ],
                 ),
               );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      )
    );
  }

  Widget _buildTopHeader(AppMatch match) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(radius: 16, backgroundColor: AppTheme.primaryBlue, child: Text(match.teamAName.length >= 2 ? match.teamAName.substring(0,2).toUpperCase() : match.teamAName.toUpperCase(), style: const TextStyle(fontSize: 12))),
                const SizedBox(width: 8),
                Expanded(child: Text(match.teamAName, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('VS', style: TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Text(match.teamBName, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.right, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                CircleAvatar(radius: 16, backgroundColor: AppTheme.primaryBlue, child: Text(match.teamBName.length >= 2 ? match.teamBName.substring(0,2).toUpperCase() : match.teamBName.toUpperCase(), style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard(ScoringState state, AppMatch match, AppInnings innings) {
    double totalOversDec = state.completedOvers + (state.validBallsInOver / 6.0);
    double crr = totalOversDec > 0 ? state.totalRuns / totalOversDec : 0.0;
    int totalBalls = (state.completedOvers * 6) + state.validBallsInOver;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E1E38), Color(0xFF10101C)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${innings.battingTeamName}, 1st inning', style: const TextStyle(color: Colors.white)),
              Row(
                children: [
                  _statItem('CRR', crr.toStringAsFixed(2)),
                  const SizedBox(width: 16),
                  _statItem('RRR', state.requiredRunRate != null ? state.requiredRunRate!.toStringAsFixed(1) : '0'),
                  const SizedBox(width: 16),
                  _statItem('Target', state.targetScore != null ? '${state.targetScore}' : '0'),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('${state.totalRuns}-${state.wickets}', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text('(${state.completedOvers}.${state.validBallsInOver})', style: const TextStyle(color: Colors.white, fontSize: 24)),
            ],
          ),
          const SizedBox(height: 8),
          Text(state.targetScore != null ? 'Need ${state.targetScore! - state.totalRuns} runs in ${(match.overs * 6) - totalBalls} balls' : '1st Innings', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildActivePlayersGrid(ScoringState state) {
    if (state.batsmanStats.isEmpty || state.bowlerStats.isEmpty) return const SizedBox.shrink();
    
    BatsmanStats striker = state.batsmanStats[state.strikerId]!;
    BatsmanStats nonStriker = state.batsmanStats[state.nonStrikerId]!;
    BowlerStats bowler = state.bowlerStats[state.bowlerId]!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(flex: 3, child: Text('Batsman', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Expanded(child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('4s', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('6s', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('SR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            ],
          ),
          const Divider(color: Colors.white24),
          _playerRow('${striker.playerName}*', striker.runs.toString(), striker.ballsFaced.toString(), striker.fours.toString(), striker.sixes.toString(), striker.strikeRate.toStringAsFixed(1)),
          const SizedBox(height: 8),
          _playerRow(nonStriker.playerName, nonStriker.runs.toString(), nonStriker.ballsFaced.toString(), nonStriker.fours.toString(), nonStriker.sixes.toString(), nonStriker.strikeRate.toStringAsFixed(1)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(flex: 3, child: Text('Bowler', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Expanded(child: Text('O', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('W', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('ER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            ],
          ),
          const Divider(color: Colors.white24),
          _playerRow(bowler.playerName, '${bowler.overs}', '${bowler.maidens}', '${bowler.runsConceded}', '${bowler.wickets}', bowler.economy.toStringAsFixed(1)),
        ],
      ),
    );
  }

  Widget _playerRow(String name, String p1, String p2, String p3, String p4, String p5) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(name, style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis)),
        Expanded(child: Text(p1, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
        Expanded(child: Text(p2, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
        Expanded(child: Text(p3, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
        Expanded(child: Text(p4, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
        Expanded(flex: 2, child: Text(p5, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
      ],
    );
  }

  Widget _buildQuickActionRow(ScoringState state, AppMatch m, AppInnings i) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B3D),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              _buildCheckbox('Wide', isWide, (v) => setState(() => isWide = v!)),
              _buildCheckbox('No Ball', isNoBall, (v) => setState(() => isNoBall = v!)),
              _buildCheckbox('Wicket', isWicket, (v) => setState(() => isWicket = v!), color: Colors.deepOrange),
              _buildCheckbox('Byes', isByes, (v) => setState(() => isByes = v!)),
            ],
          ),
          Row(
            children: [
              _buildCheckbox('Leg Byes', isLegByes, (v) => setState(() => isLegByes = v!)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => ref.read(scoringControllerProvider.notifier).undo(),
                icon: const Icon(Icons.undo, color: Colors.white),
                label: const Text('Undo', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A2E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: const Text('Swap'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged, {Color? color}) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            side: WidgetStateBorderSide.resolveWith((states) => BorderSide(color: color ?? AppTheme.primaryBlue)),
            activeColor: color ?? AppTheme.primaryBlue,
          ),
          Flexible(child: Text(label, style: TextStyle(color: color ?? AppTheme.primaryBlue, fontSize: 12), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildScorePad(AppMatch m, AppInnings i) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B3D),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _scoreCircle('0', () => _handleScore(0, m, i)),
              _scoreCircle('1', () => _handleScore(1, m, i)),
              _scoreCircle('2', () => _handleScore(2, m, i)),
              _scoreCircle('3', () => _handleScore(3, m, i)),
              _scoreCircle('4', () => _handleScore(4, m, i)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _scoreCircle('5', () => _handleScore(5, m, i)),
              const SizedBox(width: 16),
              _scoreCircle('6', () => _handleScore(6, m, i)),
              const SizedBox(width: 16),
              _scoreCircle('...', () {}),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: const Text('Retire'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _scoreCircle(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: AppTheme.primaryBlue,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _handleScore(int runs, AppMatch m, AppInnings i) {
    String? extraType;
    if (isWide) extraType = 'wide';
    if (isNoBall) extraType = 'no_ball';
    if (isByes) extraType = 'bye';
    if (isLegByes) extraType = 'leg_bye';

    if (isWicket) {
      ref.read(scoringControllerProvider.notifier).addBall(runs: runs, extraType: extraType, wicketType: 'caught', outBatsmanId: ref.read(scoringControllerProvider)!.strikerId, currentMatch: m, currentInnings: i);
    } else {
      ref.read(scoringControllerProvider.notifier).addBall(runs: runs, extraType: extraType, currentMatch: m, currentInnings: i);
    }

    setState(() {
      isWide = false;
      isNoBall = false;
      isByes = false;
      isLegByes = false;
      isWicket = false;
    });
  }

  Widget _buildBottomActionButtons(AppMatch match, AppInnings innings) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.push('/partnership/${match.matchId}/${innings.inningsId}');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
            child: const Text('Partnership'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lime[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
            child: const Text('Extras'),
          ),
        ),
      ],
    );
  }
}
