import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_player_stats.freezed.dart';
part 'match_player_stats.g.dart';

@freezed
abstract class BatsmanStats with _$BatsmanStats {
  const BatsmanStats._();

  const factory BatsmanStats({
    required String playerId,
    required String playerName,
    required int runs,
    required int ballsFaced,
    required int fours,
    required int sixes,
    required double strikeRate,
    required bool isOut,
    @Default(0) int boundaries,
  }) = _BatsmanStats;

  factory BatsmanStats.initial(String id, String name) => BatsmanStats(
        playerId: id,
        playerName: name,
        runs: 0,
        ballsFaced: 0,
        fours: 0,
        sixes: 0,
        strikeRate: 0.0,
        isOut: false,
      );

  factory BatsmanStats.fromJson(Map<String, dynamic> json) => _$BatsmanStatsFromJson(json);
}

@freezed
abstract class BowlerStats with _$BowlerStats {
  const BowlerStats._();

  const factory BowlerStats({
    required String playerId,
    required String playerName,
    required int ballsBowled,
    required double overs,
    required int runsConceded,
    required int wickets,
    required int maidens,
    required int dotBalls,
    required double economy,
  }) = _BowlerStats;

  factory BowlerStats.initial(String id, String name) => BowlerStats(
        playerId: id,
        playerName: name,
        ballsBowled: 0,
        overs: 0.0,
        runsConceded: 0,
        wickets: 0,
        maidens: 0,
        dotBalls: 0,
        economy: 0.0,
      );

  factory BowlerStats.fromJson(Map<String, dynamic> json) => _$BowlerStatsFromJson(json);
}
