// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_player_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatsmanStats _$BatsmanStatsFromJson(Map<String, dynamic> json) =>
    _BatsmanStats(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      runs: (json['runs'] as num).toInt(),
      ballsFaced: (json['ballsFaced'] as num).toInt(),
      fours: (json['fours'] as num).toInt(),
      sixes: (json['sixes'] as num).toInt(),
      strikeRate: (json['strikeRate'] as num).toDouble(),
      isOut: json['isOut'] as bool,
      boundaries: (json['boundaries'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BatsmanStatsToJson(_BatsmanStats instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'runs': instance.runs,
      'ballsFaced': instance.ballsFaced,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'strikeRate': instance.strikeRate,
      'isOut': instance.isOut,
      'boundaries': instance.boundaries,
    };

_BowlerStats _$BowlerStatsFromJson(Map<String, dynamic> json) => _BowlerStats(
  playerId: json['playerId'] as String,
  playerName: json['playerName'] as String,
  ballsBowled: (json['ballsBowled'] as num).toInt(),
  overs: (json['overs'] as num).toDouble(),
  runsConceded: (json['runsConceded'] as num).toInt(),
  wickets: (json['wickets'] as num).toInt(),
  maidens: (json['maidens'] as num).toInt(),
  dotBalls: (json['dotBalls'] as num).toInt(),
  economy: (json['economy'] as num).toDouble(),
);

Map<String, dynamic> _$BowlerStatsToJson(_BowlerStats instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'ballsBowled': instance.ballsBowled,
      'overs': instance.overs,
      'runsConceded': instance.runsConceded,
      'wickets': instance.wickets,
      'maidens': instance.maidens,
      'dotBalls': instance.dotBalls,
      'economy': instance.economy,
    };
