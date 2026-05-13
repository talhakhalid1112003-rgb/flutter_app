import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart';

class BadmintonTeamService {
  BadmintonTeamService(this._firestore);

  final FirebaseFirestore _firestore;

  static const String collectionName = 'Badminton_Teams';

  List<BadmintonTeamModel> _mapUniqueTeams(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final teamsById = <String, BadmintonTeamModel>{};

    for (final doc in snapshot.docs) {
      final team = BadmintonTeamModel.fromMap(
        doc.data(),
        documentId: doc.id,
      );
      if (team.id.isNotEmpty) {
        teamsById[team.id] = team;
      }
    }

    final teams = teamsById.values.toList();
    teams.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return teams;
  }

  Stream<List<BadmintonTeamModel>> watchUserTeams(String userId) {
    return _firestore
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return _mapUniqueTeams(snapshot);
        });
  }

  /// Fetch all badminton teams from Firestore (for dropdown selection in doubles mode)
  Future<List<BadmintonTeamModel>> fetchAllTeams() async {
    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .get();

      return _mapUniqueTeams(snapshot);
    } catch (e) {
      throw Exception('Failed to fetch badminton teams: $e');
    }
  }

  /// Stream all badminton teams from Firestore (for real-time updates)
  Stream<List<BadmintonTeamModel>> streamAllTeams() {
    return _firestore
        .collection(collectionName)
        .snapshots()
        .map((snapshot) {
          return _mapUniqueTeams(snapshot);
        });
  }

  /// Get a specific team by ID
  Future<BadmintonTeamModel?> getTeamById(String teamId) async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(teamId)
          .get();
      
      if (doc.exists && doc.data() != null) {
        return BadmintonTeamModel.fromMap(doc.data()!, documentId: doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch team: $e');
    }
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
