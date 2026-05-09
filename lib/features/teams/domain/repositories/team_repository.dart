import 'package:scoring_app/features/teams/domain/entities/app_team.dart';

abstract class TeamRepository {
  Stream<List<AppTeam>> watchTeams(String sportId, {String? teamFormat, String? createdBy});
  Stream<AppTeam?> watchTeam(String teamId);
  Future<void> createTeam(AppTeam team, {required String sportId, String? teamFormat});
  Future<void> updateTeam(AppTeam team);
  Future<void> deleteTeam(String teamId);
}
