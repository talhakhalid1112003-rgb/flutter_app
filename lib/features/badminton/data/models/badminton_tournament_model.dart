import 'package:cloud_firestore/cloud_firestore.dart';

import 'badminton_match_model.dart';
import 'badminton_team_model.dart';

class BadmintonTournamentModel {
  const BadmintonTournamentModel({
    required this.tournamentId,
    required this.userId,
    required this.createdAt,
    required this.matchType,
    required this.pointToWin,
    required this.selectedTeamIds,
    required this.selectedTeams,
    required this.semifinal1,
    required this.semifinal2,
    required this.finalMatch,
    required this.tournamentWinner,
    required this.tournamentStatus,
  });

  final String tournamentId;
  final String userId;
  final DateTime createdAt;
  final String matchType;
  final int pointToWin;
  final List<String> selectedTeamIds;
  final List<BadmintonTeamModel> selectedTeams;
  final BadmintonMatchModel? semifinal1;
  final BadmintonMatchModel? semifinal2;
  final BadmintonMatchModel? finalMatch;
  final String tournamentWinner;
  final String tournamentStatus;

  factory BadmintonTournamentModel.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    final createdAtValue = map['createdAt'];
    final selectedTeamsData = map['selectedTeams'] as List<dynamic>? ??
        const <dynamic>[];
    final semifinal1Data = map['semifinal1'];
    final semifinal2Data = map['semifinal2'];
    final finalMatchData = map['finalMatch'];

    return BadmintonTournamentModel(
      tournamentId: (documentId ?? map['tournamentId'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      matchType: (map['matchType'] ?? 'Doubles').toString(),
      pointToWin: (map['pointToWin'] as num?)?.toInt() ?? 21,
      selectedTeamIds: List<String>.from(
        map['selectedTeamIds'] as List<dynamic>? ?? const <dynamic>[],
      ),
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : DateTime.tryParse(createdAtValue?.toString() ?? '') ??
                DateTime.now(),
      selectedTeams: selectedTeamsData
          .map(
            (entry) => BadmintonTeamModel.fromMap(
              Map<String, dynamic>.from(entry as Map),
            ),
          )
          .toList(),
      semifinal1: semifinal1Data is Map
          ? BadmintonMatchModel.fromMap(
              Map<String, dynamic>.from(semifinal1Data),
            )
          : null,
      semifinal2: semifinal2Data is Map
          ? BadmintonMatchModel.fromMap(
              Map<String, dynamic>.from(semifinal2Data),
            )
          : null,
      finalMatch: finalMatchData is Map
          ? BadmintonMatchModel.fromMap(
              Map<String, dynamic>.from(finalMatchData),
            )
          : null,
      tournamentWinner: (map['tournamentWinner'] ?? '').toString(),
      tournamentStatus: (map['tournamentStatus'] ?? 'scheduled').toString(),
    );
  }

  BadmintonTournamentModel copyWith({
    String? tournamentId,
    String? userId,
    DateTime? createdAt,
    String? matchType,
    int? pointToWin,
    List<String>? selectedTeamIds,
    List<BadmintonTeamModel>? selectedTeams,
    BadmintonMatchModel? semifinal1,
    BadmintonMatchModel? semifinal2,
    BadmintonMatchModel? finalMatch,
    String? tournamentWinner,
    String? tournamentStatus,
  }) {
    return BadmintonTournamentModel(
      tournamentId: tournamentId ?? this.tournamentId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      matchType: matchType ?? this.matchType,
      pointToWin: pointToWin ?? this.pointToWin,
      selectedTeamIds: selectedTeamIds ?? this.selectedTeamIds,
      selectedTeams: selectedTeams ?? this.selectedTeams,
      semifinal1: semifinal1 ?? this.semifinal1,
      semifinal2: semifinal2 ?? this.semifinal2,
      finalMatch: finalMatch ?? this.finalMatch,
      tournamentWinner: tournamentWinner ?? this.tournamentWinner,
      tournamentStatus: tournamentStatus ?? this.tournamentStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tournamentId': tournamentId,
      'userId': userId,
      'matchType': matchType,
      'pointToWin': pointToWin,
      'selectedTeamIds': selectedTeamIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'selectedTeams': selectedTeams
          .map(
            (team) => <String, dynamic>{
              'teamId': team.teamId,
              'userId': team.userId,
              'teamType': team.teamType,
              'teamName': team.teamName,
              'players': team.players,
              'createdAt': Timestamp.fromDate(team.createdAt),
            },
          )
          .toList(),
      if (semifinal1 != null) 'semifinal1': semifinal1!.toMap(),
      if (semifinal2 != null) 'semifinal2': semifinal2!.toMap(),
      if (finalMatch != null) 'finalMatch': finalMatch!.toMap(),
      'tournamentWinner': tournamentWinner,
      'tournamentStatus': tournamentStatus,
    };
  }
}