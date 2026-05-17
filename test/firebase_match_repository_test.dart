import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoring_app/features/matches/data/repositories/firebase_match_repository.dart';
import 'package:scoring_app/features/matches/domain/entities/app_match.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_ball.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_innings.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late FirebaseMatchRepositoryImpl repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = FirebaseMatchRepositoryImpl(firestore);
  });

  test('createMatch writes sport and owner fields', () async {
    final match = AppMatch(
      matchId: 'match-1',
      teamAId: 'team-a',
      teamBId: 'team-b',
      teamAName: 'A',
      teamBName: 'B',
      tossWinner: 'team-a',
      tossDecision: 'bat',
      matchStatus: 'live',
      sportId: 'cricket',
      overs: 20,
      createdAt: DateTime(2026, 5, 17),
    );

    await repository.createMatch(match, sportId: 'cricket', createdBy: 'user-1');

    final doc = await firestore.collection('matches').doc('match-1').get();
    expect(doc.data()?['sportId'], 'cricket');
    expect(doc.data()?['createdBy'], 'user-1');
  });

  test('saveDeliveryBatch stores nested ball under innings', () async {
    final match = AppMatch(
      matchId: 'match-1',
      teamAId: 'team-a',
      teamBId: 'team-b',
      teamAName: 'A',
      teamBName: 'B',
      tossWinner: 'team-a',
      tossDecision: 'bat',
      matchStatus: 'live',
      sportId: 'cricket',
      overs: 20,
      createdAt: DateTime(2026, 5, 17),
    );
    final innings = AppInnings(
      inningsId: 'innings-1',
      matchId: 'match-1',
      battingTeamName: 'A',
      bowlingTeamName: 'B',
      battingTeamId: 'team-a',
      bowlingTeamId: 'team-b',
      totalRuns: 0,
      wickets: 0,
      overs: 0,
    );
    final ball = AppBall(
      ballId: 'ball-1',
      matchId: 'match-1',
      inningsId: 'innings-1',
      overNumber: 1,
      ballNumber: 1,
      batsmanName: 'Player 1',
      bowlerName: 'Bowler 1',
      runs: 1,
      extraType: null,
      wicketType: null,
      timestamp: DateTime(2026, 5, 17),
    );

    await repository.saveDeliveryBatch(
      match: match,
      innings: innings,
      ball: ball,
    );

    final ballDoc = await firestore
        .collection('matches')
        .doc('match-1')
        .collection('innings')
        .doc('innings-1')
        .collection('balls')
        .doc('ball-1')
        .get();

    expect(ballDoc.exists, isTrue);
    expect(ballDoc.data()?['ballId'], 'ball-1');
  });

  test('saveBall writes nested ball document under innings', () async {
    final ball = AppBall(
      ballId: 'ball-1',
      matchId: 'match-1',
      inningsId: 'innings-1',
      overNumber: 1,
      ballNumber: 1,
      batsmanName: 'Player 1',
      bowlerName: 'Bowler 1',
      runs: 4,
      extraType: null,
      wicketType: null,
      timestamp: DateTime(2026, 5, 17),
    );

    await repository.saveBall(ball);

    final ballDoc = await firestore
        .collection('matches')
        .doc('match-1')
        .collection('innings')
        .doc('innings-1')
        .collection('balls')
        .doc('ball-1')
        .get();

    expect(ballDoc.exists, isTrue);
    expect(ballDoc.data()?['runs'], 4);
  });
}