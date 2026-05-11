import 'package:cloud_firestore/cloud_firestore.dart';

class BadmintonRoundSummary {
  const BadmintonRoundSummary({
    required this.roundNumber,
    required this.teamAScore,
    required this.teamBScore,
    required this.winner,
    required this.suddenDeathUsed,
    required this.completedAt,
  });

  final int roundNumber;
  final int teamAScore;
  final int teamBScore;
  final String winner;
  final bool suddenDeathUsed;
  final DateTime completedAt;

  factory BadmintonRoundSummary.fromMap(Map<String, dynamic> map) {
    final completedAtValue = map['completedAt'];
    return BadmintonRoundSummary(
      roundNumber: (map['roundNumber'] as num?)?.toInt() ?? 1,
      teamAScore: (map['teamAScore'] as num?)?.toInt() ?? 0,
      teamBScore: (map['teamBScore'] as num?)?.toInt() ?? 0,
      winner: (map['winner'] ?? '').toString(),
      suddenDeathUsed: map['suddenDeathUsed'] as bool? ?? false,
      completedAt: completedAtValue is Timestamp
          ? completedAtValue.toDate()
          : DateTime.tryParse(completedAtValue?.toString() ?? '') ??
                DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roundNumber': roundNumber,
      'teamAScore': teamAScore,
      'teamBScore': teamBScore,
      'winner': winner,
      'suddenDeathUsed': suddenDeathUsed,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }
}
