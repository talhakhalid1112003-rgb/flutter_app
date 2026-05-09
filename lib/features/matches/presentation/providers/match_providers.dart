import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_app/core/providers/firebase_providers.dart';
import 'package:scoring_app/features/auth/providers/auth_provider.dart';
import 'package:scoring_app/features/matches/data/repositories/firebase_match_repository.dart';
import 'package:scoring_app/features/matches/domain/repositories/match_repository.dart';
import 'package:scoring_app/features/matches/domain/entities/app_match.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_innings.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_ball.dart';
import 'package:scoring_app/features/scoring/domain/entities/player_stats.dart';

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseMatchRepositoryImpl(firestore);
});

final matchesProvider = StreamProvider<List<AppMatch>>((ref) {
  final user = ref.watch(authControllerProvider).value;
  final userId = user?.uid;
  return ref.watch(matchRepositoryProvider).watchMatches('cricket', createdBy: userId);
});

final inningsProvider = StreamProvider.family<List<AppInnings>, String>((ref, matchId) {
  return ref.watch(matchRepositoryProvider).watchInnings(matchId);
});

final ballsProvider = StreamProvider.family<List<AppBall>, Map<String, String>>((ref, params) {
  return ref.watch(matchRepositoryProvider).watchBalls(params['matchId']!, params['inningsId']!);
});

final playerStatsProvider = StreamProvider.family<List<PlayerStats>, String>((ref, matchId) {
  return ref.watch(matchRepositoryProvider).watchPlayerStats(matchId);
});
