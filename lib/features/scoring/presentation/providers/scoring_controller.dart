// ignore_for_file: undefined_getter, undefined_named_parameter, undefined_method, unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:scoring_app/features/scoring/presentation/providers/scoring_state.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_ball.dart';
import 'package:scoring_app/features/matches/domain/entities/app_match.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_innings.dart';
import 'package:scoring_app/features/matches/presentation/providers/match_providers.dart';
import 'package:scoring_app/features/scoring/domain/entities/match_player_stats.dart';

class ScoringController extends Notifier<ScoringState?> {
  final List<ScoringState> _stateHistory = [];
  final List<AppBall> _ballHistory = [];

  bool get canUndo => _stateHistory.isNotEmpty;

  @override
  ScoringState? build() {
    return null;
  }

  void initialize({
    required String matchId,
    required String inningsId,
    required String strikerId,
    required String strikerName,
    required String nonStrikerId,
    required String nonStrikerName,
    required String bowlerId,
    required String bowlerName,
    int? targetScore,
    int? totalOvers,
  }) {
    state = ScoringState.initial(
      matchId: matchId,
      inningsId: inningsId,
      strikerId: strikerId,
      strikerName: strikerName,
      nonStrikerId: nonStrikerId,
      nonStrikerName: nonStrikerName,
      bowlerId: bowlerId,
      bowlerName: bowlerName,
      targetScore: targetScore,
      totalOvers: totalOvers,
    );
  }

  Future<void> addBall({
    required int runs,
    String? extraType,
    String? wicketType,
    String? outBatsmanId,
    required AppMatch currentMatch,
    required AppInnings currentInnings,
  }) async {
    if (state == null) return;
    if (state!.currentPhase == MatchPhase.completed ||
        state!.currentPhase == MatchPhase.inningsBreak)
      return;

    final st = state!;
    state = st.copyWith(isLoading: true, error: null);

    try {
      bool isWide = extraType == 'wide';
      bool isNoBall = extraType == 'no_ball';
      bool isLegBye = extraType == 'leg_bye';
      bool isBye = extraType == 'bye';

      bool isValidBall = !isWide && !isNoBall;
      bool batsmanFaced = !isWide;

      int batsmanRuns = (isWide || isLegBye || isBye) ? 0 : runs;
      int extraRunsPenalty = (isWide || isNoBall) ? 1 : 0;
      int bowlerRuns = (isLegBye || isBye) ? 0 : runs + extraRunsPenalty;
      int totalDeliveryRuns = runs + extraRunsPenalty;

      // Free Hit Logic
      bool isFreeHitActive = st.isFreeHit;
      if (isFreeHitActive && wicketType != null && wicketType != 'run_out') {
        wicketType = null; // Only run_out allowed on free hit
      }

      // 1. Calculate Batsman Stats
      final bStats = Map<String, BatsmanStats>.from(st.batsmanStats);
      BatsmanStats strikerStats = bStats[st.strikerId]!;
      int newFours = strikerStats.fours + (batsmanRuns == 4 ? 1 : 0);
      int newSixes = strikerStats.sixes + (batsmanRuns == 6 ? 1 : 0);
      int newBatsmanRuns = strikerStats.runs + batsmanRuns;
      int newBallsFaced = strikerStats.ballsFaced + (batsmanFaced ? 1 : 0);
      double srikerSR = newBallsFaced > 0
          ? (newBatsmanRuns / newBallsFaced) * 100
          : 0.0;

      bStats[st.strikerId] = strikerStats.copyWith(
        runs: newBatsmanRuns,
        ballsFaced: newBallsFaced,
        fours: newFours,
        sixes: newSixes,
        boundaries: newFours + newSixes,
        strikeRate: srikerSR,
      );

      // 2. Calculate Bowler Stats
      final bwStats = Map<String, BowlerStats>.from(st.bowlerStats);
      BowlerStats activeBowler = bwStats[st.bowlerId]!;
      int newBallsBowled = activeBowler.ballsBowled + (isValidBall ? 1 : 0);
      double newOvers = (newBallsBowled ~/ 6) + ((newBallsBowled % 6) / 10);
      int newBowlerRuns = activeBowler.runsConceded + bowlerRuns;
      int newWickets =
          activeBowler.wickets +
          ((wicketType != null && wicketType != 'run_out') ? 1 : 0);
      int newDotBalls =
          activeBowler.dotBalls + (totalDeliveryRuns == 0 ? 1 : 0);
      double newEconomy = newOvers > 0
          ? (newBowlerRuns / newBallsBowled * 6)
          : 0.0;

      // Maiden logic evaluated at the end of the over later...

      bwStats[st.bowlerId] = activeBowler.copyWith(
        ballsBowled: newBallsBowled,
        overs: newOvers,
        runsConceded: newBowlerRuns,
        wickets: newWickets,
        dotBalls: newDotBalls,
        economy: newEconomy,
      );

      // 3. Match State calculations
      int newTotalRuns = st.totalRuns + totalDeliveryRuns;
      int newWicketCount = st.wickets + (wicketType != null ? 1 : 0);
      int newValidBalls = st.validBallsInOver + (isValidBall ? 1 : 0);
      int newCompletedOvers = st.completedOvers;

      if (newValidBalls == 6) {
        newCompletedOvers += 1;
        newValidBalls = 0;

        // Maiden Detection
        int runsInThisOver =
            0; // In a full professional app, we'd sum currentOverBalls, but let's approximate or just flag.
        // We will rely on checking currentOverBalls.
      }

      int newPartnershipRuns = st.partnershipRuns + totalDeliveryRuns;
      int newPartnershipBalls = st.partnershipBalls + (isValidBall ? 1 : 0);

      if (wicketType != null) {
        newPartnershipRuns = 0;
        newPartnershipBalls = 0;
        if (outBatsmanId != null && bStats.containsKey(outBatsmanId)) {
          bStats[outBatsmanId] = bStats[outBatsmanId]!.copyWith(isOut: true);
        } else {
          bStats[st.strikerId] = bStats[st.strikerId]!.copyWith(isOut: true);
        }
      }

      // 4. Strike Rotation
      String nextStrikerId = st.strikerId;
      String nextNonStrikerId = st.nonStrikerId;
      if (runs % 2 != 0) {
        nextStrikerId = st.nonStrikerId;
        nextNonStrikerId = st.strikerId;
      }
      if (newValidBalls == 0 && isValidBall) {
        // End of over swap
        final temp = nextStrikerId;
        nextStrikerId = nextNonStrikerId;
        nextNonStrikerId = temp;
      }

      // 5. Build Ball & List tracking
      final ball = AppBall(
        ballId: const Uuid().v4(),
        matchId: st.matchId,
        inningsId: st.inningsId,
        overNumber: st.completedOvers,
        ballNumber: isValidBall ? (newValidBalls == 0 ? 6 : newValidBalls) : 0,
        batsmanName: bStats[st.strikerId]!.playerName,
        bowlerName: bwStats[st.bowlerId]!.playerName,
        runs: runs,
        extraType: extraType,
        wicketType: wicketType,
        timestamp: DateTime.now(),
      );

      List<AppBall> newOverBalls = List.from(st.currentOverBalls);
      newOverBalls.add(ball);
      if (newValidBalls == 0 && isValidBall) {
        // Detect maiden over before clearing
        int runsInOver = newOverBalls.fold(0, (sum, b) {
          int r = b.runs;
          if (b.extraType == 'wide' || b.extraType == 'no_ball') r += 1;
          if (b.extraType == 'leg_bye' || b.extraType == 'bye') return sum;
          return sum + r;
        });
        if (runsInOver == 0) {
          bwStats[st.bowlerId] = bwStats[st.bowlerId]!.copyWith(
            maidens: bwStats[st.bowlerId]!.maidens + 1,
          );
        }
        newOverBalls.clear(); // Ready for next over
      }

      // Check Innings transitions and Target
      MatchPhase nextPhase = st.currentPhase;
      String? resultMsg = currentMatch.matchResult;

      if (st.currentPhase == MatchPhase.firstInnings) {
        if (newWicketCount == 10 ||
            (currentMatch.overs * 6) ==
                (newCompletedOvers * 6 + newValidBalls)) {
          nextPhase = MatchPhase.inningsBreak;
        }
      } else if (st.currentPhase == MatchPhase.secondInnings &&
          st.targetScore != null) {
        if (newTotalRuns >= st.targetScore!) {
          nextPhase = MatchPhase.completed;
          int ballsRem =
              (currentMatch.overs * 6) -
              (newCompletedOvers * 6 + newValidBalls);
          resultMsg =
              "${currentMatch.teamBName} won by ${10 - newWicketCount} wickets with $ballsRem balls remaining";
        } else if (newWicketCount == 10 ||
            (currentMatch.overs * 6) ==
                (newCompletedOvers * 6 + newValidBalls)) {
          nextPhase = MatchPhase.completed;
          if (newTotalRuns == st.targetScore! - 1) {
            resultMsg = "Match Tied";
            nextPhase = MatchPhase.superOver;
          } else {
            resultMsg =
                "${currentMatch.teamAName} won by ${st.targetScore! - newTotalRuns - 1} runs";
          }
        }
      }

      int? rNeeded = st.targetScore != null
          ? (st.targetScore! - newTotalRuns)
          : null;
      int? balRem =
          (currentMatch.overs * 6) - (newCompletedOvers * 6 + newValidBalls);
      double? rrr = (rNeeded != null && rNeeded > 0 && balRem > 0)
          ? (rNeeded / (balRem / 6))
          : null;

      // 6. DB Updates
      final updatedInnings = currentInnings.copyWith(
        totalRuns: newTotalRuns,
        wickets: newWicketCount,
        overs: newCompletedOvers + (newValidBalls / 10),
      );

      final updatedMatch = currentMatch.copyWith(
        currentPhase: nextPhase,
        matchResult: resultMsg,
        currentStrikerId: nextStrikerId,
        currentNonStrikerId: nextNonStrikerId,
        currentBowlerId: st.bowlerId,
      );

      _stateHistory.add(st.copyWith());
      _ballHistory.add(ball);

      await ref
          .read(matchRepositoryProvider)
          .saveDeliveryBatch(
            match: updatedMatch,
            innings: updatedInnings,
            ball: ball,
          );

      state = st.copyWith(
        totalRuns: newTotalRuns,
        wickets: newWicketCount,
        validBallsInOver: newValidBalls,
        completedOvers: newCompletedOvers,
        batsmanStats: bStats,
        bowlerStats: bwStats,
        partnershipRuns: newPartnershipRuns,
        partnershipBalls: newPartnershipBalls,
        strikerId: nextStrikerId,
        nonStrikerId: nextNonStrikerId,
        isFreeHit: isNoBall,
        currentOverBalls: newOverBalls,
        currentPhase: nextPhase,
        runsNeeded: rNeeded,
        ballsRemaining: balRem,
        requiredRunRate: rrr,
        isLoading: false,
      );
    } catch (e) {
      _stateHistory.removeLast();
      _ballHistory.removeLast();
      state = st.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updatePlayers(
    String newStriker,
    String newNonStriker,
    String newBowler,
    String strikerName,
    String nonStrikerName,
    String bowlerName,
  ) {
    if (state == null) return;

    final bStats = Map<String, BatsmanStats>.from(state!.batsmanStats);
    if (!bStats.containsKey(newStriker))
      bStats[newStriker] = BatsmanStats.initial(newStriker, strikerName);
    if (!bStats.containsKey(newNonStriker))
      bStats[newNonStriker] = BatsmanStats.initial(
        newNonStriker,
        nonStrikerName,
      );

    final bwStats = Map<String, BowlerStats>.from(state!.bowlerStats);
    if (!bwStats.containsKey(newBowler))
      bwStats[newBowler] = BowlerStats.initial(newBowler, bowlerName);

    state = state!.copyWith(
      strikerId: newStriker,
      strikerName: strikerName,
      nonStrikerId: newNonStriker,
      nonStrikerName: nonStrikerName,
      bowlerId: newBowler,
      bowlerName: bowlerName,
      batsmanStats: bStats,
      bowlerStats: bwStats,
    );
  }

  Future<void> undo() async {
    if (!canUndo || state == null) return;

    final st = state!;
    state = st.copyWith(isLoading: true);

    try {
      final lastState = _stateHistory.removeLast();
      final lastBall = _ballHistory.removeLast();

      await ref
          .read(matchRepositoryProvider)
          .deleteBall(lastBall.matchId, lastBall.inningsId, lastBall.ballId);
      state = lastState.copyWith(isLoading: false);
    } catch (e) {
      state = st.copyWith(isLoading: false, error: "Undo failed: $e");
    }
  }
}

final scoringControllerProvider =
    NotifierProvider<ScoringController, ScoringState?>(() {
      return ScoringController();
    });
