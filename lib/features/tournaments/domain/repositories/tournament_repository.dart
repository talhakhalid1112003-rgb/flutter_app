import 'package:smart_cricket_scorer/features/tournaments/domain/entities/app_tournament.dart';

abstract class TournamentRepository {
  Future<void> createTournament(AppTournament tournament);
  Stream<List<AppTournament>> watchTournaments();
  Future<AppTournament?> getTournament(String id);
  Future<void> updateTournament(AppTournament tournament);
  Future<void> deleteTournament(String id);
}
