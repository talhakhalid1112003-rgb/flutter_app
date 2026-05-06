import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/tournaments/presentation/providers/tournament_providers.dart';

class TournamentDashboardScreen extends ConsumerWidget {
  final String tournamentId;

  const TournamentDashboardScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentAsync = ref.watch(tournamentDetailsProvider(tournamentId));
    final standingsAsync = ref.watch(tournamentStandingsProvider(tournamentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: tournamentAsync.when(
        data: (tournament) {
          if (tournament == null)
            return const Center(child: Text("Tournament not found"));

          return standingsAsync.when(
            data: (standings) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      tournament.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Format: ${tournament.format} | Overs: ${tournament.overs}',
                      style: const TextStyle(color: AppTheme.primaryBlue),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/new-match', extra: tournamentId);
                      },
                      icon: const Icon(Icons.sports_cricket),
                      label: const Text('Start Tournament Match'),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Points Table',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPointsTable(standings),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () async {
                        // End Tournament logic
                        await ref
                            .read(tournamentRepositoryProvider)
                            .updateTournament(
                              tournament.copyWith(status: 'completed'),
                            );
                        if (context.mounted) context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('End Tournament'),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) =>
                Center(child: Text('Error loading standings: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildPointsTable(List<TeamStanding> standings) {
    if (standings.isEmpty) {
      return const Center(
        child: Text(
          'No teams in this tournament',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: DataTable(
        columnSpacing: 12,
        horizontalMargin: 8,
        headingRowColor: WidgetStateProperty.all(AppTheme.cardColorDark),
        dataRowColor: WidgetStateProperty.all(const Color(0xFF14142B)),
        headingTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlue,
        ),
        dataTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
        columns: const [
          DataColumn(label: Text('No.')),
          DataColumn(label: Text('Teams')),
          DataColumn(label: Text('M')),
          DataColumn(label: Text('W')),
          DataColumn(label: Text('L')),
          DataColumn(label: Text('D')),
          DataColumn(label: Text('Pts')),
          DataColumn(label: Text('NRR')),
        ],
        rows: List.generate(standings.length, (index) {
          final team = standings[index];
          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(
                SizedBox(
                  width: 80,
                  child: Text(team.teamName, overflow: TextOverflow.ellipsis),
                ),
              ),
              DataCell(Text('${team.matchesPlayed}')),
              DataCell(Text('${team.wins}')),
              DataCell(Text('${team.losses}')),
              DataCell(Text('${team.draws}')),
              DataCell(
                Text(
                  '${team.points}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
              DataCell(Text(team.nrr.toStringAsFixed(2))),
            ],
          );
        }),
      ),
    );
  }
}
