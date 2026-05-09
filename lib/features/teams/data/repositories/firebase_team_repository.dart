import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoring_app/core/error/failures.dart';
import 'package:scoring_app/features/teams/domain/entities/app_team.dart';
import 'package:scoring_app/features/teams/domain/repositories/team_repository.dart';

class FirebaseTeamRepositoryImpl implements TeamRepository {
  final FirebaseFirestore _firestore;

  FirebaseTeamRepositoryImpl(this._firestore);

  @override
  Stream<List<AppTeam>> watchTeams(String sportId, {String? teamFormat, String? createdBy}) {
    if (createdBy == null) {
      return const Stream.empty();
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('teams')
        .where('sportId', isEqualTo: sportId)
        .where('createdBy', isEqualTo: createdBy);

    if (sportId == 'badminton' && teamFormat != null) {
      query = query.where('teamFormat', isEqualTo: teamFormat);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppTeam.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<void> createTeam(
    AppTeam team, {
    required String sportId,
    String? teamFormat,
  }) async {
    try {
      final data = <String, dynamic>{...team.toJson(), 'sportId': sportId};
      if (sportId == 'badminton' && teamFormat != null) {
        data['teamFormat'] = teamFormat;
      }
      await _firestore.collection('teams').doc(team.teamId).set(data);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
  @override
Stream<AppTeam?> watchTeam(String teamId) {
  return _firestore
      .collection('teams')
      .doc(teamId)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return null;

        return AppTeam.fromJson(doc.data()!);
      });
}

  @override
  Future<void> updateTeam(AppTeam team) async {
    try {
      await _firestore
          .collection('teams')
          .doc(team.teamId)
          .update(team.toJson());
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
