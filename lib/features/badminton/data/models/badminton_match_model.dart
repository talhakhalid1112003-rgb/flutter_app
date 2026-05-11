import 'package:cloud_firestore/cloud_firestore.dart';

import 'badminton_round_summary.dart';

class BadmintonMatchModel {
  const BadmintonMatchModel({
    required this.matchId,
    required this.userId,
    required this.matchType,
    required this.selectedPoints,
    required this.teamAName,
    required this.teamBName,
    required this.players,
    required this.scores,
    required this.roundsWon,
    required this.finalWinner,
    required this.createdAt,
    required this.matchStatus,
    required this.currentRound,
    required this.deuceTieCount,
    required this.suddenDeathActive,
    required this.roundSummaries,
  });

  final String matchId;
  final String userId;
  final String matchType;
  final int selectedPoints;
  final String teamAName;
  final String teamBName;
  final Map<String, List<String>> players;
  final Map<String, int> scores;
  final Map<String, int> roundsWon;
  final String finalWinner;
  final DateTime createdAt;
  final String matchStatus;
  final int currentRound;
  final int deuceTieCount;
  final bool suddenDeathActive;
  final List<BadmintonRoundSummary> roundSummaries;

  List<String> get teamAPlayers => players['teamA'] ?? <String>[];
  List<String> get teamBPlayers => players['teamB'] ?? <String>[];
  int get teamAScore => scores['teamA'] ?? 0;
  int get teamBScore => scores['teamB'] ?? 0;
  int get roundsWonA => roundsWon['teamA'] ?? 0;
  int get roundsWonB => roundsWon['teamB'] ?? 0;

  factory BadmintonMatchModel.fromMap(Map<String, dynamic> map) {
    final createdAtValue = map['createdAt'];
    final playersMap =
        map['players'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final scoresMap =
        map['scores'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final roundsWonMap =
        map['roundsWon'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final roundSummariesData =
        map['roundSummaries'] as List<dynamic>? ?? const <dynamic>[];

    return BadmintonMatchModel(
      matchId: (map['matchId'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      matchType: (map['matchType'] ?? 'Singles').toString(),
      selectedPoints: (map['selectedPoints'] as num?)?.toInt() ?? 21,
      teamAName: (map['teamAName'] ?? '').toString(),
      teamBName: (map['teamBName'] ?? '').toString(),
      players: <String, List<String>>{
        'teamA': List<String>.from(
          playersMap['teamA'] as List<dynamic>? ?? const <dynamic>[],
        ),
        'teamB': List<String>.from(
          playersMap['teamB'] as List<dynamic>? ?? const <dynamic>[],
        ),
      },
      scores: <String, int>{
        'teamA': (scoresMap['teamA'] as num?)?.toInt() ?? 0,
        'teamB': (scoresMap['teamB'] as num?)?.toInt() ?? 0,
      },
      roundsWon: <String, int>{
        'teamA': (roundsWonMap['teamA'] as num?)?.toInt() ?? 0,
        'teamB': (roundsWonMap['teamB'] as num?)?.toInt() ?? 0,
      },
      finalWinner: (map['finalWinner'] ?? '').toString(),
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : DateTime.tryParse(createdAtValue?.toString() ?? '') ??
                DateTime.now(),
      matchStatus: (map['matchStatus'] ?? 'live').toString(),
      currentRound: (map['currentRound'] as num?)?.toInt() ?? 1,
      deuceTieCount: (map['deuceTieCount'] as num?)?.toInt() ?? 0,
      suddenDeathActive: map['suddenDeathActive'] as bool? ?? false,
      roundSummaries: roundSummariesData
          .map(
            (entry) => BadmintonRoundSummary.fromMap(
              Map<String, dynamic>.from(entry as Map),
            ),
          )
          .toList(),
    );
  }

  BadmintonMatchModel copyWith({
    String? matchId,
    String? userId,
    String? matchType,
    int? selectedPoints,
    String? teamAName,
    String? teamBName,
    Map<String, List<String>>? players,
    Map<String, int>? scores,
    Map<String, int>? roundsWon,
    String? finalWinner,
    DateTime? createdAt,
    String? matchStatus,
    int? currentRound,
    int? deuceTieCount,
    bool? suddenDeathActive,
    List<BadmintonRoundSummary>? roundSummaries,
  }) {
    return BadmintonMatchModel(
      matchId: matchId ?? this.matchId,
      userId: userId ?? this.userId,
      matchType: matchType ?? this.matchType,
      selectedPoints: selectedPoints ?? this.selectedPoints,
      teamAName: teamAName ?? this.teamAName,
      teamBName: teamBName ?? this.teamBName,
      players: players ?? this.players,
      scores: scores ?? this.scores,
      roundsWon: roundsWon ?? this.roundsWon,
      finalWinner: finalWinner ?? this.finalWinner,
      createdAt: createdAt ?? this.createdAt,
      matchStatus: matchStatus ?? this.matchStatus,
      currentRound: currentRound ?? this.currentRound,
      deuceTieCount: deuceTieCount ?? this.deuceTieCount,
      suddenDeathActive: suddenDeathActive ?? this.suddenDeathActive,
      roundSummaries: roundSummaries ?? this.roundSummaries,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchId': matchId,
      'userId': userId,
      'matchType': matchType,
      'selectedPoints': selectedPoints,
      'teamAName': teamAName,
      'teamBName': teamBName,
      'players': <String, dynamic>{
        'teamA': teamAPlayers,
        'teamB': teamBPlayers,
      },
      'scores': <String, dynamic>{'teamA': teamAScore, 'teamB': teamBScore},
      'roundsWon': <String, dynamic>{'teamA': roundsWonA, 'teamB': roundsWonB},
      'finalWinner': finalWinner,
      'createdAt': Timestamp.fromDate(createdAt),
      'matchStatus': matchStatus,
      'currentRound': currentRound,
      'deuceTieCount': deuceTieCount,
      'suddenDeathActive': suddenDeathActive,
      'roundSummaries': roundSummaries
          .map((summary) => summary.toMap())
          .toList(),
    };
  }
}
