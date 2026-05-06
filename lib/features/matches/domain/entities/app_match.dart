import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_match.freezed.dart';
part 'app_match.g.dart';

enum MatchPhase {
  initial,
  firstInnings,
  inningsBreak,
  secondInnings,
  superOver,
  completed
}

@freezed
abstract class AppMatch with _$AppMatch {
  const factory AppMatch({
    required String matchId,
    required String teamAName,
    required String teamBName,
    String? teamAId,
    String? teamBId,
    String? tournamentId,
    required int overs,
    required String tossWinner,
    required String tossDecision, // 'bat' or 'bowl'
    required String matchStatus, // 'upcoming', 'live', 'completed'
    @Default(MatchPhase.initial) MatchPhase currentPhase,
    int? targetScore,
    String? matchResult,
    String? currentStrikerId,
    String? currentNonStrikerId,
    String? currentBowlerId,
    required DateTime createdAt,
  }) = _AppMatch;

  factory AppMatch.fromJson(Map<String, dynamic> json) => _$AppMatchFromJson(json);
}
