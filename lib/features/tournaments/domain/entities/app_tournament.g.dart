// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppTournament _$AppTournamentFromJson(
  Map<String, dynamic> json,
) => _AppTournament(
  tournamentId: json['tournamentId'] as String,
  name: json['name'] as String,
  format: json['format'] as String,
  overs: (json['overs'] as num).toInt(),
  teamIds: (json['teamIds'] as List<dynamic>).map((e) => e as String).toList(),
  matchIds:
      (json['matchIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppTournamentToJson(_AppTournament instance) =>
    <String, dynamic>{
      'tournamentId': instance.tournamentId,
      'name': instance.name,
      'format': instance.format,
      'overs': instance.overs,
      'teamIds': instance.teamIds,
      'matchIds': instance.matchIds,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
