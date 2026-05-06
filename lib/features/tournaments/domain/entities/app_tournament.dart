import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_tournament.freezed.dart';
part 'app_tournament.g.dart';

@freezed
abstract class AppTournament with _$AppTournament {
  const factory AppTournament({
    required String tournamentId,
    required String name,
    required String format, // Test, ODI, T20
    required int overs,
    required List<String> teamIds,
    required String status, // active, completed
    required DateTime createdAt,
  }) = _AppTournament;

  factory AppTournament.fromJson(Map<String, dynamic> json) => _$AppTournamentFromJson(json);
}
