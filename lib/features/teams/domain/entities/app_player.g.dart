// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppPlayer _$AppPlayerFromJson(Map<String, dynamic> json) => _AppPlayer(
  playerId: json['playerId'] as String,
  playerName: json['playerName'] as String,
  teamId: json['teamId'] as String,
  role: json['role'] as String,
  battingStyle: json['battingStyle'] as String,
  bowlingStyle: json['bowlingStyle'] as String,
);

Map<String, dynamic> _$AppPlayerToJson(_AppPlayer instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'teamId': instance.teamId,
      'role': instance.role,
      'battingStyle': instance.battingStyle,
      'bowlingStyle': instance.bowlingStyle,
    };
