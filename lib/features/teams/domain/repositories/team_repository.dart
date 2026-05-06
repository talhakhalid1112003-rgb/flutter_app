import 'package:scoring_app/features/teams/domain/entities/app_team.dart';

abstract class TeamRepository {
  Stream<List<AppTeam>> watchTeams();
  Future<void> createTeam(AppTeam team);
  Future<void> updateTeam(AppTeam team);
  Future<void> deleteTeam(String teamId);
}
