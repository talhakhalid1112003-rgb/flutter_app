import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:scoring_app/features/badminton/data/models/badminton_tournament_model.dart';

class BadmintonTournamentHistoryService {
  BadmintonTournamentHistoryService(this._firestore);

  final FirebaseFirestore _firestore;

  static const String collectionName = 'Badminton_Tournament_History';

  Stream<List<BadmintonTournamentModel>> watchUserTournaments(String userId) {
    return _firestore
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final tournaments = snapshot.docs
              .map(
                (doc) => BadmintonTournamentModel.fromMap(
                  doc.data(),
                  documentId: doc.id,
                ),
              )
              .toList();
          tournaments.sort(
            (left, right) => right.createdAt.compareTo(left.createdAt),
          );
          return tournaments;
        });
  }

  Future<BadmintonTournamentModel?> getTournamentById(String tournamentId) async {
    final snapshot = await _firestore.collection(collectionName).doc(tournamentId).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }
    return BadmintonTournamentModel.fromMap(
      snapshot.data()!,
      documentId: snapshot.id,
    );
  }

  Future<BadmintonTournamentModel> saveTournament(
    BadmintonTournamentModel tournament,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to save a badminton tournament.');
    }

    final tournamentId = tournament.tournamentId.isEmpty
        ? await generateNextTournamentId()
        : tournament.tournamentId;

    final record = tournament.copyWith(
      tournamentId: tournamentId,
      userId: user.uid,
      createdAt: tournament.createdAt,
    );

    await _firestore.collection(collectionName).doc(tournamentId).set(record.toMap());
    return record;
  }

  Future<String> generateNextTournamentId() async {
    final snapshot = await _firestore.collection(collectionName).get();
    var highestSequence = 0;
    final pattern = RegExp(r'^badminton_tournament-(\d+)$');

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
    return 'badminton_tournament-${nextSequence.toString().padLeft(2, '0')}';
  }
}