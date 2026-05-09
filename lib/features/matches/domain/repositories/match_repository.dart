import 'package:scoring_app/features/scoring/domain/entities/app_ball.dart';
import 'package:scoring_app/features/matches/domain/entities/app_match.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_innings.dart';
import 'package:scoring_app/features/scoring/domain/entities/player_stats.dart';

abstract class MatchRepository {
  Stream<List<AppMatch>> watchMatches(String sportId, {String? createdBy});
  Future<void> createMatch(AppMatch match, {required String sportId, String? createdBy});
  Future<void> updateMatchStatus(String matchId, String status);

  Stream<List<AppInnings>> watchInnings(String matchId);
  Future<void> saveInnings(AppInnings innings);

  Stream<List<AppBall>> watchBalls(String matchId, String inningsId);
  Future<void> saveBall(AppBall ball);

  Stream<List<PlayerStats>> watchPlayerStats(String matchId);
  Future<void> savePlayerStats(PlayerStats stats);

  Future<void> deleteBall(String matchId, String inningsId, String ballId);

  // Advanced Batch Saving
  Future<void> saveDeliveryBatch({
    required AppMatch match,
    required AppInnings innings,
    required AppBall ball,
  });
}
