import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cricket_scorer/features/teams/domain/entities/app_player.dart';
import 'package:smart_cricket_scorer/features/teams/domain/repositories/player_repository.dart';
import 'package:smart_cricket_scorer/core/error/failures.dart';

class FirebasePlayerRepositoryImpl implements PlayerRepository {
  final FirebaseFirestore _firestore;

  FirebasePlayerRepositoryImpl(this._firestore);

  @override
  Stream<List<AppPlayer>> watchPlayersForTeam(String teamId) {
    return _firestore
        .collection('players')
        .where('teamId', isEqualTo: teamId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AppPlayer.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<void> addPlayer(AppPlayer player) async {
    try {
      await _firestore.collection('players').doc(player.playerId).set(player.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updatePlayer(AppPlayer player) async {
    try {
      await _firestore.collection('players').doc(player.playerId).update(player.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> removePlayer(String playerId) async {
    try {
      await _firestore.collection('players').doc(playerId).delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
