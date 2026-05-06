import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_stats.freezed.dart';
part 'player_stats.g.dart';

@freezed
abstract class PlayerStats with _$PlayerStats {
  const factory PlayerStats({
    required String playerId,
    required String playerName,
    required String matchId,
    required int runs,
    required int balls,
    required int fours,
    required int sixes,
    required int wickets,
    required double oversBowled,
    required int runsConceded,
  }) = _PlayerStats;

  factory PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);
}
