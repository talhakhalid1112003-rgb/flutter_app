// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_innings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppInnings _$AppInningsFromJson(Map<String, dynamic> json) => _AppInnings(
  inningsId: json['inningsId'] as String,
  matchId: json['matchId'] as String,
  battingTeamName: json['battingTeamName'] as String,
  bowlingTeamName: json['bowlingTeamName'] as String,
  battingTeamId: json['battingTeamId'] as String?,
  bowlingTeamId: json['bowlingTeamId'] as String?,
  totalRuns: (json['totalRuns'] as num).toInt(),
  wickets: (json['wickets'] as num).toInt(),
  overs: (json['overs'] as num).toDouble(),
);

Map<String, dynamic> _$AppInningsToJson(_AppInnings instance) =>
    <String, dynamic>{
      'inningsId': instance.inningsId,
      'matchId': instance.matchId,
      'battingTeamName': instance.battingTeamName,
      'bowlingTeamName': instance.bowlingTeamName,
      'battingTeamId': instance.battingTeamId,
      'bowlingTeamId': instance.bowlingTeamId,
      'totalRuns': instance.totalRuns,
      'wickets': instance.wickets,
      'overs': instance.overs,
    };
