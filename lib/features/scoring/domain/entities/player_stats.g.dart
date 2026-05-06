// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) => _PlayerStats(
  playerId: json['playerId'] as String,
  playerName: json['playerName'] as String,
  matchId: json['matchId'] as String,
  runs: (json['runs'] as num).toInt(),
  balls: (json['balls'] as num).toInt(),
  fours: (json['fours'] as num).toInt(),
  sixes: (json['sixes'] as num).toInt(),
  wickets: (json['wickets'] as num).toInt(),
  oversBowled: (json['oversBowled'] as num).toDouble(),
  runsConceded: (json['runsConceded'] as num).toInt(),
);

Map<String, dynamic> _$PlayerStatsToJson(_PlayerStats instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'matchId': instance.matchId,
      'runs': instance.runs,
      'balls': instance.balls,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'wickets': instance.wickets,
      'oversBowled': instance.oversBowled,
      'runsConceded': instance.runsConceded,
    };
