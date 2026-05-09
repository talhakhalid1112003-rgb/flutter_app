import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_app/core/providers/firebase_providers.dart';
import 'package:scoring_app/features/tournaments/data/repositories/firebase_tournament_repository.dart';
import 'package:scoring_app/features/tournaments/domain/repositories/tournament_repository.dart';
import 'package:scoring_app/features/tournaments/domain/entities/app_tournament.dart';
import 'package:scoring_app/features/matches/presentation/providers/match_providers.dart';
import 'package:scoring_app/features/teams/presentation/providers/team_providers.dart';
import 'package:scoring_app/features/matches/domain/entities/app_match.dart';
import 'package:scoring_app/features/scoring/domain/entities/app_innings.dart';

class TeamStanding {
  final String teamId;
  final String teamName;
  int matchesPlayed = 0;
  int wins = 0;
  int losses = 0;
  int draws = 0;
  int runsScored = 0;
  int ballsFaced = 0;
  int runsConceded = 0;
  int ballsBowled = 0;

  TeamStanding({required this.teamId, required this.teamName});

  int get points => (wins * 2) + (draws * 1);

  double get nrr {
    double scoredRate = ballsFaced > 0
        ? (runsScored / (ballsFaced / 6.0))
        : 0.0;
    double concededRate = ballsBowled > 0
        ? (runsConceded / (ballsBowled / 6.0))
        : 0.0;
    return scoredRate - concededRate;
  }
}

int _calculateBalls(double overs) {
  int completedOvers = overs.truncate();
  int balls = ((overs - completedOvers) * 10).round();
  return (completedOvers * 6) + balls;
}

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseTournamentRepositoryImpl(firestore);
});

final tournamentsProvider = StreamProvider<List<AppTournament>>((ref) {
  return ref.watch(tournamentRepositoryProvider).watchTournaments();
});

final tournamentDetailsProvider = FutureProvider.family<AppTournament?, String>(
  (ref, id) {
    return ref.watch(tournamentRepositoryProvider).getTournament(id);
  },
);

final tournamentStandingsProvider =
    FutureProvider.family<List<TeamStanding>, String>((
      ref,
      tournamentId,
    ) async {
      final tournament = await ref.watch(
        tournamentDetailsProvider(tournamentId).future,
      );
      if (tournament == null) return [];

      final allTeams = await ref.watch(teamsProvider('cricket').future);
      final tournamentTeams = allTeams
          .where((t) => tournament.teamIds.contains(t.teamId))
          .toList();

      Map<String, TeamStanding> standings = {
        for (var t in tournamentTeams)
          t.teamId: TeamStanding(teamId: t.teamId, teamName: t.teamName),
      };

      final allMatches = await ref.watch(matchesProvider.future);
      final tMatches = allMatches
          .where(
            (m) =>
                m.tournamentId == tournamentId &&
                m.currentPhase == MatchPhase.completed,
          )
          .toList();

      final matchRepo = ref.read(matchRepositoryProvider);

      for (var match in tMatches) {
        if (!standings.containsKey(match.teamAId) || !standings.containsKey(match.teamBId))
          {
            continue;
          }
        // Fetch innings
        final inningsList = await matchRepo.watchInnings(match.matchId).first;
        if (inningsList.isEmpty) continue;

        AppInnings? teamAInnings;
        AppInnings? teamBInnings;

        for (var inn in inningsList) {
          if (inn.battingTeamId == match.teamAId) teamAInnings = inn;
          if (inn.battingTeamId == match.teamBId) teamBInnings = inn;
        }

        if (teamAInnings == null || teamBInnings == null) continue;

        int teamARuns = teamAInnings.totalRuns;
        int teamBRuns = teamBInnings.totalRuns;

        int teamABallsFaced = teamAInnings.wickets == 10
            ? match.overs * 6
            : _calculateBalls(teamAInnings.overs);
        int teamBBallsFaced = teamBInnings.wickets == 10
            ? match.overs * 6
            : _calculateBalls(teamBInnings.overs);

        // Update match results
        standings[match.teamAId!]!.matchesPlayed++;
        standings[match.teamBId!]!.matchesPlayed++;

        if (teamARuns > teamBRuns) {
          standings[match.teamAId!]!.wins++;
          standings[match.teamBId!]!.losses++;
        } else if (teamBRuns > teamARuns) {
          standings[match.teamBId!]!.wins++;
          standings[match.teamAId!]!.losses++;
        } else {
          standings[match.teamAId!]!.draws++;
          standings[match.teamBId!]!.draws++;
        }

        // Update runs and overs
        // Team A
        standings[match.teamAId!]!.runsScored += teamARuns;
        standings[match.teamAId!]!.ballsFaced += teamABallsFaced;
        standings[match.teamAId!]!.runsConceded += teamBRuns;
        standings[match.teamAId!]!.ballsBowled += teamBBallsFaced;

        // Team B
        standings[match.teamBId!]!.runsScored += teamBRuns;
        standings[match.teamBId!]!.ballsFaced += teamBBallsFaced;
        standings[match.teamBId!]!.runsConceded += teamARuns;
        standings[match.teamBId!]!.ballsBowled += teamABallsFaced;
      }

      var sortedStandings = standings.values.toList();
      sortedStandings.sort((a, b) {
        if (b.points != a.points) return b.points.compareTo(a.points);
        return b.nrr.compareTo(a.nrr);
      });

      return sortedStandings;
    });
