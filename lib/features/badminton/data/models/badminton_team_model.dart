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

  String get id => teamId;

  factory BadmintonTeamModel.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    final createdAtValue = map['createdAt'];
    final playersData = map['player'] as List<dynamic>? ??
        map['players'] as List<dynamic>? ??
        const <dynamic>[];
    return BadmintonTeamModel(
      teamId: (documentId ?? map['teamId'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      teamType: (map['teamType'] ?? 'Doubles').toString(),
      teamName: (map['teamName'] ?? '').toString(),
      players: List<String>.from(playersData),
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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BadmintonTeamModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'teamName': teamName,
      'player': players,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
