import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';

class BadmintonHistoryService {
  BadmintonHistoryService(this._firestore);

  final FirebaseFirestore _firestore;

  static const String collectionName = 'Badminton_Match_History';

  Stream<List<BadmintonMatchModel>> watchUserMatches(String userId) {
    return _firestore
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final matches = snapshot.docs
              .map((doc) => BadmintonMatchModel.fromMap(doc.data()))
              .toList();
          matches.sort(
            (left, right) => right.createdAt.compareTo(left.createdAt),
          );
          return matches;
        });
  }

  Future<BadmintonMatchModel?> getMatchById(String matchId) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .doc(matchId)
        .get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }
    return BadmintonMatchModel.fromMap(snapshot.data()!);
  }

  Stream<BadmintonMatchModel?> watchMatchById(String matchId) {
    return _firestore.collection(collectionName).doc(matchId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return BadmintonMatchModel.fromMap(snapshot.data()!);
    });
  }

  Future<BadmintonMatchModel> createMatch(BadmintonMatchModel match) async {
    final matchId = await generateNextMatchId();
    final created = match.copyWith(matchId: matchId);
    await _firestore
        .collection(collectionName)
        .doc(matchId)
        .set(created.toMap());
    return created;
  }

  Future<void> saveMatch(BadmintonMatchModel match) async {
    await _firestore
        .collection(collectionName)
        .doc(match.matchId)
        .set(match.toMap(), SetOptions(merge: true));
  }

  Future<void> updateMatch(String matchId, Map<String, dynamic> updates) async {
    await _firestore.collection(collectionName).doc(matchId).update(updates);
  }

  Future<String> generateNextMatchId() async {
    final snapshot = await _firestore.collection(collectionName).get();
    var highestSequence = 0;
    final pattern = RegExp(r'^badminton_match_history-(\d+)$');

    for (final doc in snapshot.docs) {
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
    return 'badminton_match_history-${nextSequence.toString().padLeft(2, '0')}';
  }
}
