import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_app/core/providers/firebase_providers.dart';
import 'package:scoring_app/features/teams/data/repositories/firebase_team_repository.dart';
import 'package:scoring_app/features/teams/domain/repositories/team_repository.dart';
import 'package:scoring_app/features/teams/domain/entities/app_team.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseTeamRepositoryImpl(firestore);
});

final teamsProvider = StreamProvider<List<AppTeam>>((ref) {
  return ref.watch(teamRepositoryProvider).watchTeams();
});
