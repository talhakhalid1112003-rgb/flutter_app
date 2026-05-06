// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppMatch _$AppMatchFromJson(Map<String, dynamic> json) => _AppMatch(
  matchId: json['matchId'] as String,
  teamAName: json['teamAName'] as String,
  teamBName: json['teamBName'] as String,
  teamAId: json['teamAId'] as String?,
  teamBId: json['teamBId'] as String?,
  overs: (json['overs'] as num).toInt(),
  tossWinner: json['tossWinner'] as String,
  tossDecision: json['tossDecision'] as String,
  matchStatus: json['matchStatus'] as String,
  currentPhase:
      $enumDecodeNullable(_$MatchPhaseEnumMap, json['currentPhase']) ??
      MatchPhase.initial,
  targetScore: (json['targetScore'] as num?)?.toInt(),
  matchResult: json['matchResult'] as String?,
  currentStrikerId: json['currentStrikerId'] as String?,
  currentNonStrikerId: json['currentNonStrikerId'] as String?,
  currentBowlerId: json['currentBowlerId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppMatchToJson(_AppMatch instance) => <String, dynamic>{
  'matchId': instance.matchId,
  'teamAName': instance.teamAName,
  'teamBName': instance.teamBName,
  'teamAId': instance.teamAId,
  'teamBId': instance.teamBId,
  'overs': instance.overs,
  'tossWinner': instance.tossWinner,
  'tossDecision': instance.tossDecision,
  'matchStatus': instance.matchStatus,
  'currentPhase': _$MatchPhaseEnumMap[instance.currentPhase]!,
  'targetScore': instance.targetScore,
  'matchResult': instance.matchResult,
  'currentStrikerId': instance.currentStrikerId,
  'currentNonStrikerId': instance.currentNonStrikerId,
  'currentBowlerId': instance.currentBowlerId,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$MatchPhaseEnumMap = {
  MatchPhase.initial: 'initial',
  MatchPhase.firstInnings: 'firstInnings',
  MatchPhase.inningsBreak: 'inningsBreak',
  MatchPhase.secondInnings: 'secondInnings',
  MatchPhase.superOver: 'superOver',
  MatchPhase.completed: 'completed',
};
