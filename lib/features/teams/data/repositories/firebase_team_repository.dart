import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoring_app/features/teams/domain/entities/app_team.dart';
import 'package:scoring_app/features/teams/domain/repositories/team_repository.dart';
import 'package:scoring_app/core/error/failures.dart';

class FirebaseTeamRepositoryImpl implements TeamRepository {
  final FirebaseFirestore _firestore;

  FirebaseTeamRepositoryImpl(this._firestore);

  @override
  Stream<List<AppTeam>> watchTeams() {
    return _firestore.collection('teams').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppTeam.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<void> createTeam(AppTeam team) async {
    try {
      await _firestore.collection('teams').doc(team.teamId).set(team.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateTeam(AppTeam team) async {
    try {
      await _firestore.collection('teams').doc(team.teamId).update(team.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteTeam(String teamId) async {
    try {
      await _firestore.collection('teams').doc(teamId).delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
