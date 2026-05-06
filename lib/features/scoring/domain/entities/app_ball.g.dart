// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_ball.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppBall _$AppBallFromJson(Map<String, dynamic> json) => _AppBall(
  ballId: json['ballId'] as String,
  matchId: json['matchId'] as String,
  inningsId: json['inningsId'] as String,
  overNumber: (json['overNumber'] as num).toInt(),
  ballNumber: (json['ballNumber'] as num).toInt(),
  batsmanName: json['batsmanName'] as String,
  bowlerName: json['bowlerName'] as String,
  runs: (json['runs'] as num).toInt(),
  extraType: json['extraType'] as String?,
  wicketType: json['wicketType'] as String?,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$AppBallToJson(_AppBall instance) => <String, dynamic>{
  'ballId': instance.ballId,
  'matchId': instance.matchId,
  'inningsId': instance.inningsId,
  'overNumber': instance.overNumber,
  'ballNumber': instance.ballNumber,
  'batsmanName': instance.batsmanName,
  'bowlerName': instance.bowlerName,
  'runs': instance.runs,
  'extraType': instance.extraType,
  'wicketType': instance.wicketType,
  'timestamp': instance.timestamp.toIso8601String(),
};
