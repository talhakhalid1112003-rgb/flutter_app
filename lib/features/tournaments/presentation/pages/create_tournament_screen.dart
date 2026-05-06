import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cricket_scorer/core/config/app_theme.dart';
import 'package:smart_cricket_scorer/features/teams/presentation/providers/team_providers.dart';
import 'package:smart_cricket_scorer/features/tournaments/domain/entities/app_tournament.dart';
import 'package:smart_cricket_scorer/features/tournaments/presentation/providers/tournament_providers.dart';
import 'package:uuid/uuid.dart';

class CreateTournamentScreen extends ConsumerStatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  ConsumerState<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends ConsumerState<CreateTournamentScreen> {
  final _nameCtrl = TextEditingController();
  final _oversCtrl = TextEditingController(text: '20');
  String _format = 'T20';
  final Set<String> _selectedTeamIds = {};

  void _createTournament() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty || _selectedTeamIds.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter name and select at least 2 teams.')));
      return;
    }

    final overs = int.tryParse(_oversCtrl.text) ?? 20;
    final tournamentId = const Uuid().v4();

    final tournament = AppTournament(
      tournamentId: tournamentId,
      name: name,
      format: _format,
      overs: overs,
      teamIds: _selectedTeamIds.toList(),
      status: 'active',
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(tournamentRepositoryProvider).createTournament(tournament);
      if (mounted) context.go('/tournament-dashboard/$tournamentId');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Start New Tournament')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Tournament Name'),
            ),
            const SizedBox(height: 24),
            const Text('Match Format', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildFormatRadio('Test'),
                _buildFormatRadio('ODI'),
                _buildFormatRadio('T20'),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _oversCtrl,
              decoration: const InputDecoration(labelText: 'Manual Overs'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const Text('Select Teams', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: teamsAsync.when(
                data: (teams) {
                  if (teams.isEmpty) return const Center(child: Text("No teams available. Create teams first."));
                  return ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      final isSelected = _selectedTeamIds.contains(team.teamId);
                      return CheckboxListTile(
                        title: Text(team.teamName),
                        value: isSelected,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedTeamIds.add(team.teamId);
                            } else {
                              _selectedTeamIds.remove(team.teamId);
                            }
                          });
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _createTournament,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Start Tournament'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatRadio(String label) {
    final isSelected = _format == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _format = label),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue.withAlpha(51) : Colors.transparent,
            border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.white24),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: isSelected ? AppTheme.primaryBlue : Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }
}
