import 'package:smart_cricket_scorer/features/teams/domain/entities/app_player.dart';

abstract class PlayerRepository {
  Stream<List<AppPlayer>> watchPlayersForTeam(String teamId);
  Future<void> addPlayer(AppPlayer player);
  Future<void> updatePlayer(AppPlayer player);
  Future<void> removePlayer(String playerId);
}
