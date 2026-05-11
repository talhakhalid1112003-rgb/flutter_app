import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart';

class BadmintonTeamService {
  BadmintonTeamService(this._firestore);

  final FirebaseFirestore _firestore;

  static const String collectionName = 'Badminton_Teams';

  Stream<List<BadmintonTeamModel>> watchUserTeams(String userId) {
    return _firestore
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final teams = snapshot.docs
              .map((doc) => BadmintonTeamModel.fromMap(doc.data()))
              .toList();
          teams.sort(
            (left, right) => right.createdAt.compareTo(left.createdAt),
          );
          return teams;
        });
  }

  Future<BadmintonTeamModel> saveTeam(BadmintonTeamModel team) async {
    final teamId = team.teamId.isEmpty
        ? 'badminton_team_${DateTime.now().millisecondsSinceEpoch}'
        : team.teamId;
    final created = team.copyWith(teamId: teamId);
    await _firestore
        .collection(collectionName)
        .doc(teamId)
        .set(created.toMap());
    return created;
  }
}
