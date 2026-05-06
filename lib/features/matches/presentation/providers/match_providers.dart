import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cricket_scorer/core/providers/firebase_providers.dart';
import 'package:smart_cricket_scorer/features/matches/data/repositories/firebase_match_repository.dart';
import 'package:smart_cricket_scorer/features/matches/domain/repositories/match_repository.dart';
import 'package:smart_cricket_scorer/features/matches/domain/entities/app_match.dart';
import 'package:smart_cricket_scorer/features/scoring/domain/entities/app_innings.dart';
import 'package:smart_cricket_scorer/features/scoring/domain/entities/app_ball.dart';
import 'package:smart_cricket_scorer/features/scoring/domain/entities/player_stats.dart';

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseMatchRepositoryImpl(firestore);
});

final matchesProvider = StreamProvider<List<AppMatch>>((ref) {
  return ref.watch(matchRepositoryProvider).watchMatches();
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
