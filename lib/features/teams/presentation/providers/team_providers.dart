import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_app/core/providers/firebase_providers.dart';
import 'package:scoring_app/features/auth/providers/auth_provider.dart';
import 'package:scoring_app/features/teams/data/repositories/firebase_team_repository.dart';
import 'package:scoring_app/features/teams/domain/repositories/team_repository.dart';
import 'package:scoring_app/features/teams/domain/entities/app_team.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseTeamRepositoryImpl(firestore);
});

final teamsProvider = StreamProvider.family<List<AppTeam>, String>((ref, sportId) {
  final user = ref.watch(authControllerProvider).value;
  final userId = user?.uid;
  return ref.watch(teamRepositoryProvider).watchTeams(sportId, createdBy: userId);
});

final teamProvider = StreamProvider.family<AppTeam?, String>((ref, teamId) {
  return ref.watch(teamRepositoryProvider).watchTeam(teamId);
});
