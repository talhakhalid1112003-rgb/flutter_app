import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoring_app/features/tournaments/domain/entities/app_tournament.dart';
import 'package:scoring_app/features/tournaments/domain/repositories/tournament_repository.dart';

class FirebaseTournamentRepositoryImpl implements TournamentRepository {
  final FirebaseFirestore _firestore;

  FirebaseTournamentRepositoryImpl(this._firestore);

  @override
  Future<void> createTournament(AppTournament tournament) async {
    await _firestore
        .collection('tournaments')
        .doc(tournament.tournamentId)
        .set(tournament.toJson());
  }

  @override
  Stream<List<AppTournament>> watchTournaments() {
    return _firestore
        .collection('tournaments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppTournament.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<AppTournament?> getTournament(String id) async {
    final doc = await _firestore.collection('tournaments').doc(id).get();
    if (!doc.exists) return null;
    return AppTournament.fromJson(doc.data()!);
  }

  @override
  Future<void> updateTournament(AppTournament tournament) async {
    await _firestore
        .collection('tournaments')
        .doc(tournament.tournamentId)
        .update(tournament.toJson());
  }

  @override
  Future<void> deleteTournament(String id) async {
    await _firestore.collection('tournaments').doc(id).delete();
  }
}
