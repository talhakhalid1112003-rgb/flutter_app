import 'package:cloud_firestore/cloud_firestore.dart';

class BadmintonTeamModel {
  const BadmintonTeamModel({
    required this.teamId,
    required this.userId,
    required this.teamType,
    required this.teamName,
    required this.players,
    required this.createdAt,
  });

  final String teamId;
  final String userId;
  final String teamType;
  final String teamName;
  final List<String> players;
  final DateTime createdAt;

  factory BadmintonTeamModel.fromMap(Map<String, dynamic> map) {
    final createdAtValue = map['createdAt'];
    return BadmintonTeamModel(
      teamId: (map['teamId'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      teamType: (map['teamType'] ?? 'Singles').toString(),
      teamName: (map['teamName'] ?? '').toString(),
      players: List<String>.from(
        map['players'] as List<dynamic>? ?? const <dynamic>[],
      ),
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : DateTime.tryParse(createdAtValue?.toString() ?? '') ??
                DateTime.now(),
    );
  }

  BadmintonTeamModel copyWith({
    String? teamId,
    String? userId,
    String? teamType,
    String? teamName,
    List<String>? players,
    DateTime? createdAt,
  }) {
    return BadmintonTeamModel(
      teamId: teamId ?? this.teamId,
      userId: userId ?? this.userId,
      teamType: teamType ?? this.teamType,
      teamName: teamName ?? this.teamName,
      players: players ?? this.players,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'teamId': teamId,
      'userId': userId,
      'teamType': teamType,
      'teamName': teamName,
      'players': players,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
