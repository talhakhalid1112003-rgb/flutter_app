import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_innings.freezed.dart';
part 'app_innings.g.dart';

@freezed
abstract class AppInnings with _$AppInnings {
  const factory AppInnings({
    required String inningsId,
    required String matchId,
    required String battingTeamName,
    required String bowlingTeamName,
    String? battingTeamId,
    String? bowlingTeamId,
    required int totalRuns,
    required int wickets,
    required double overs,
  }) = _AppInnings;

  factory AppInnings.fromJson(Map<String, dynamic> json) => _$AppInningsFromJson(json);
}
