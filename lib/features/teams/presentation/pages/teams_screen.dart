import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/providers/firebase_providers.dart';
import 'package:scoring_app/features/teams/presentation/providers/team_providers.dart';
import 'package:scoring_app/features/teams/domain/entities/app_team.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:uuid/uuid.dart';

class TeamsScreen extends ConsumerStatefulWidget {
  const TeamsScreen({super.key});

  @override
  ConsumerState<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamsScreen> {
  String _selectedSport = 'cricket';
  final List<String> _sportOptions = const ['cricket', 'badminton'];

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamsProvider(_selectedSport));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _sportOptions.map((sport) {
                final isSelected = sport == _selectedSport;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSport = sport),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryBlue.withAlpha(40) : Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryBlue : Colors.white24,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        sport.toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? AppTheme.primaryBlue : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: teamsAsync.when(
              data: (teams) {
                if (teams.isEmpty) {
                  return const Center(child: Text('No teams found for this sport.'));
                }
                return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: AppTheme.cardColorDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryBlue,
                          child: Text(team.teamName.substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(team.teamName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                        subtitle: const Text('Matches: 0   Won: 0   Lost: 0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => _showEditTeamDialog(context, ref, team),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTeam(context, ref, team),
                            ),
                          ],
                        ),
                        onTap: () => context.push(
                          Uri(
                            path: '/teams/${team.teamId}',
                            queryParameters: {'sportId': _selectedSport},
                          ).toString(),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTeamDialog(context, ref),
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddTeamDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    String? selectedFormat;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Team'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ctrl,
                  decoration: const InputDecoration(labelText: 'Team Name'),
                ),
                if (_selectedSport == 'badminton') ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedFormat,
                    items: ['Singles', 'Doubles']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedFormat = v),
                    decoration: const InputDecoration(labelText: 'Format'),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (ctrl.text.isEmpty) return;
                if (_selectedSport == 'badminton' && selectedFormat == null) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please select a format for badminton team.')));
                  return;
                }
                final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
                if (userId == null) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please login before creating a team.')));
                  }
                  return;
                }
                final team = AppTeam(
                  teamId: const Uuid().v4(),
                  teamName: ctrl.text.trim(),
                  createdBy: userId,
                  format: selectedFormat?.toLowerCase(),
                );
                await ref.read(teamRepositoryProvider).createTeam(
                      team,
                      sportId: _selectedSport,
                    );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTeamDialog(BuildContext context, WidgetRef ref, AppTeam team) {
    final ctrl = TextEditingController(text: team.teamName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Team'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Team Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              final updatedTeam = team.copyWith(teamName: ctrl.text.trim());
              await ref.read(teamRepositoryProvider).updateTeam(updatedTeam);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteTeam(BuildContext context, WidgetRef ref, AppTeam team) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Team'),
        content: Text('Are you sure you want to delete ${team.teamName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await ref.read(teamRepositoryProvider).deleteTeam(team.teamId);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
