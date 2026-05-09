// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppTeam _$AppTeamFromJson(Map<String, dynamic> json) => _AppTeam(
  teamId: json['teamId'] as String,
  teamName: json['teamName'] as String,
  createdBy: json['createdBy'] as String,
  format: json['format'] as String?,
);

Map<String, dynamic> _$AppTeamToJson(_AppTeam instance) => <String, dynamic>{
  'teamId': instance.teamId,
  'teamName': instance.teamName,
  'createdBy': instance.createdBy,
  'format': instance.format,
};
