import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart';

class BadmintonTeamService {
  BadmintonTeamService(this._firestore);

  final FirebaseFirestore _firestore;

  static const String collectionName = 'Badminton_Teams';

  List<BadmintonTeamModel> _mapUserTeams(
    QuerySnapshot<Map<String, dynamic>> snapshot,
    String userId,
  ) {
    final teamsById = <String, BadmintonTeamModel>{};

    for (final doc in snapshot.docs) {
      final team = BadmintonTeamModel.fromMap(
        doc.data(),
        documentId: doc.id,
      );
      if (team.id.isNotEmpty && team.userId == userId) {
        teamsById[team.id] = team;
      }
    }

    final teams = teamsById.values.toList();
    teams.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return teams;
  }

  Future<List<BadmintonTeamModel>> fetchTeams({required String userId}) async {
    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .where('userId', isEqualTo: userId)
          .get();
      return _mapUserTeams(snapshot, userId);
    } catch (e) {
      throw Exception('Failed to fetch badminton teams: $e');
    }
  }

  Stream<List<BadmintonTeamModel>> watchCurrentUserTeams(String userId) {
    return _firestore
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => _mapUserTeams(snapshot, userId));
  }

  /// Get a specific team by ID
  Future<BadmintonTeamModel?> getTeamById(String teamId) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(teamId).get();

      if (doc.exists && doc.data() != null) {
        return BadmintonTeamModel.fromMap(doc.data()!, documentId: doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch team: $e');
    }
  }

  Future<void> saveDoubleTeam({
    required String teamName,
    required List<String> players,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to save a badminton team.');
    }

    final normalizedTeamName = teamName.trim();
    final normalizedPlayers = players.map((player) => player.trim()).toList();

    if (normalizedTeamName.isEmpty) {
      throw Exception('Team name is required.');
    }
    if (normalizedPlayers.length != 2) {
      throw Exception('Exactly 2 players are required.');
    }
    if (normalizedPlayers.any((player) => player.isEmpty)) {
      throw Exception('Player names cannot be empty.');
    }
    if (normalizedPlayers[0] == normalizedPlayers[1]) {
      throw Exception('Player names must be unique within a team.');
    }

    final existingTeamsSnapshot = await _firestore
        .collection(collectionName)
        .where('userId', isEqualTo: user.uid)
        .get();

    final existingTeams = _mapUserTeams(existingTeamsSnapshot, user.uid);
    final hasDuplicateTeamName = existingTeams.any(
      (team) => team.teamName.toLowerCase() == normalizedTeamName.toLowerCase(),
    );
    if (hasDuplicateTeamName) {
      throw Exception('Team name already exists for this user.');
    }

    final nextTeamId = _generateNextTeamId(existingTeamsSnapshot.docs);
    final team = BadmintonTeamModel(
      teamId: nextTeamId,
      userId: user.uid,
      teamType: 'Doubles',
      teamName: normalizedTeamName,
      players: normalizedPlayers,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(collectionName)
        .doc(nextTeamId)
        .set(team.toMap());
  }

  Future<BadmintonTeamModel> saveTeam(BadmintonTeamModel team) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to save a badminton team.');
    }

    final normalizedPlayers = team.players.map((player) => player.trim()).toList();
    final nextTeamId = await _generateNextTeamIdFromStore();
    final created = BadmintonTeamModel(
      teamId: nextTeamId,
      userId: user.uid,
      teamType: 'Doubles',
      teamName: team.teamName.trim(),
      players: normalizedPlayers,
      createdAt: DateTime.now(),
    );

    await _firestore.collection(collectionName).doc(nextTeamId).set(created.toMap());
    return created;
  }

  Future<String> _generateNextTeamIdFromStore() async {
    final snapshot = await _firestore.collection(collectionName).get();
    return _generateNextTeamId(snapshot.docs);
  }

  String _generateNextTeamId(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    var highestSequence = 0;
    final pattern = RegExp(r'^Badminton_Team-(\d+)$');

    for (final doc in docs) {
      final match = pattern.firstMatch(doc.id);
      if (match == null) {
        continue;
      }

      final sequence = int.tryParse(match.group(1) ?? '0') ?? 0;
      if (sequence > highestSequence) {
        highestSequence = sequence;
      }
    }

    final nextSequence = highestSequence + 1;
    return 'Badminton_Team-${nextSequence.toString().padLeft(2, '0')}';
  }
}
