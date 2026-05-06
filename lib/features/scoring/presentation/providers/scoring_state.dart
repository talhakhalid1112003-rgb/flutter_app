import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scoring_app/features/scoring/domain/entities/match_player_stats.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_ball.dart';
import 'package:scoring_app/features/matches/domain/entities/app_match.dart';

part 'scoring_state.freezed.dart';

@freezed
abstract class ScoringState with _$ScoringState {
  const factory ScoringState({
    required String matchId,
    required String inningsId,
    required String strikerId,
    required String strikerName,
    required String nonStrikerId,
    required String nonStrikerName,
    required String bowlerId,
    required String bowlerName,
    required int totalRuns,
    required int wickets,
    required int validBallsInOver, // 0 to 6
    required int completedOvers,
    @Default(0) int partnershipRuns,
    @Default(0) int partnershipBalls,
    @Default({}) Map<String, BatsmanStats> batsmanStats,
    @Default({}) Map<String, BowlerStats> bowlerStats,
    @Default(false) bool isFreeHit,
    @Default([]) List<AppBall> currentOverBalls,
    @Default(MatchPhase.initial) MatchPhase currentPhase,
    int? targetScore,
    int? runsNeeded,
    int? ballsRemaining,
    double? requiredRunRate,
    @Default(false) bool isLoading,
    String? error,
  }) = _ScoringState;

  factory ScoringState.initial({
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
    final Map<String, BatsmanStats> bStats = {
      strikerId: BatsmanStats.initial(strikerId, strikerName),
      nonStrikerId: BatsmanStats.initial(nonStrikerId, nonStrikerName),
    };

    final Map<String, BowlerStats> bwStats = {
      bowlerId: BowlerStats.initial(bowlerId, bowlerName),
    };

    int? runsN = targetScore;
    int? ballsR = totalOvers != null ? totalOvers * 6 : null;
    double? rrr = (runsN != null && ballsR != null && ballsR > 0)
        ? (runsN / (ballsR / 6))
        : null;

    return ScoringState(
      matchId: matchId,
      inningsId: inningsId,
      strikerId: strikerId,
      strikerName: strikerName,
      nonStrikerId: nonStrikerId,
      nonStrikerName: nonStrikerName,
      bowlerId: bowlerId,
      bowlerName: bowlerName,
      totalRuns: 0,
      wickets: 0,
      validBallsInOver: 0,
      completedOvers: 0,
      targetScore: targetScore,
      runsNeeded: runsN,
      ballsRemaining: ballsR,
      requiredRunRate: rrr,
      batsmanStats: bStats,
      bowlerStats: bwStats,
      currentPhase: MatchPhase.firstInnings,
    );
  }
}
