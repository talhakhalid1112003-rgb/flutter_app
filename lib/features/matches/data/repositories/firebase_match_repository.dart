import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoring_app/features/matches/domain/entities/app_match.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_innings.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_ball.dart';
import 'package:scoring_app/features/scoring/domain/entities/player_stats.dart';
import 'package:scoring_app/features/matches/domain/repositories/match_repository.dart';
import 'package:scoring_app/core/error/failures.dart';

class FirebaseMatchRepositoryImpl implements MatchRepository {
  final FirebaseFirestore _firestore;

  FirebaseMatchRepositoryImpl(this._firestore);

  @override
  Stream<List<AppMatch>> watchMatches(String sportId) {
    return _firestore
        .collection('matches')
        .where('sportId', isEqualTo: sportId)
        .snapshots()
        .map((snapshot) {
          final matches = snapshot.docs
              .map((doc) => AppMatch.fromJson(doc.data()))
              .toList();

          matches.sort(
            (left, right) => right.createdAt.compareTo(left.createdAt),
          );
          return matches;
        });
  }

  @override
  Future<void> createMatch(AppMatch match, {required String sportId}) async {
    try {
      final data = <String, dynamic>{...match.toJson(), 'sportId': sportId};
      await _firestore.collection('matches').doc(match.matchId).set(data);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateMatchStatus(String matchId, String status) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'matchStatus': status,
      });
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Stream<List<AppInnings>> watchInnings(String matchId) {
    return _firestore
        .collection('matches')
        .doc(matchId)
        .collection('innings')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AppInnings.fromJson(doc.data()))
              .toList();
        });
  }

  @override
  Future<void> saveInnings(AppInnings innings) async {
    try {
      await _firestore
          .collection('matches')
          .doc(innings.matchId)
          .collection('innings')
          .doc(innings.inningsId)
          .set(innings.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Stream<List<AppBall>> watchBalls(String matchId, String inningsId) {
    return _firestore
        .collection('matches')
        .doc(matchId)
        .collection('innings')
        .doc(inningsId)
        .collection('balls')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AppBall.fromJson(doc.data()))
              .toList();
        });
  }

  @override
  Future<void> saveBall(AppBall ball) async {
    try {
      await _firestore
          .collection('matches')
          .doc(ball.matchId)
          .collection('innings')
          .doc(ball.inningsId)
          .collection('balls')
          .doc(ball.ballId)
          .set(ball.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Stream<List<PlayerStats>> watchPlayerStats(String matchId) {
    return _firestore
        .collection('matches')
        .doc(matchId)
        .collection('playerStats')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => PlayerStats.fromJson(doc.data()))
              .toList();
        });
  }

  @override
  Future<void> savePlayerStats(PlayerStats stats) async {
    try {
      await _firestore
          .collection('matches')
          .doc(stats.matchId)
          .collection('playerStats')
          .doc(stats.playerId)
          .set(stats.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteBall(
    String matchId,
    String inningsId,
    String ballId,
  ) async {
    try {
      await _firestore
          .collection('matches')
          .doc(matchId)
          .collection('balls')
          .doc(ballId)
          .delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> saveDeliveryBatch({
    required AppMatch match,
    required AppInnings innings,
    required AppBall ball,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final matchRef = _firestore.collection('matches').doc(match.matchId);
        final inningsRef = matchRef
            .collection('innings')
            .doc(innings.inningsId);
        final ballRef = matchRef.collection('balls').doc(ball.ballId);

        // Within transaction, we just use transaction.set() or update()
        transaction.set(matchRef, match.toJson());
        transaction.set(inningsRef, innings.toJson());
        transaction.set(ballRef, ball.toJson());
      });
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
