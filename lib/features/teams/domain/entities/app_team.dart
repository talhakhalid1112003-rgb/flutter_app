import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_team.freezed.dart';
part 'app_team.g.dart';

@freezed
abstract class AppTeam with _$AppTeam {
  const factory AppTeam({
    required String teamId,
    required String teamName,
    required String createdBy,
  }) = _AppTeam;

  factory AppTeam.fromJson(Map<String, dynamic> json) => _$AppTeamFromJson(json);
}
