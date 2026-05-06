import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_app/core/providers/firebase_providers.dart';
import 'package:scoring_app/features/teams/data/repositories/firebase_player_repository.dart';
import 'package:scoring_app/features/teams/domain/repositories/player_repository.dart';
import 'package:scoring_app/features/teams/domain/entities/app_player.dart';

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebasePlayerRepositoryImpl(firestore);
});

final playersByTeamProvider = StreamProvider.family<List<AppPlayer>, String>((
  ref,
  teamId,
) {
  return ref.watch(playerRepositoryProvider).watchPlayersForTeam(teamId);
});
