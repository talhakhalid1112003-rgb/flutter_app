import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_player.freezed.dart';
part 'app_player.g.dart';

@freezed
abstract class AppPlayer with _$AppPlayer {
  const factory AppPlayer({
    required String playerId,
    required String playerName,
    required String teamId,
    required String role, // Batter, Bowler, All-Rounder, Wicket Keeper
    required String battingStyle,
    required String bowlingStyle,
  }) = _AppPlayer;

  factory AppPlayer.fromJson(Map<String, dynamic> json) => _$AppPlayerFromJson(json);
}
