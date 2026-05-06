import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cricket_scorer/features/teams/presentation/providers/team_providers.dart';
import 'package:smart_cricket_scorer/features/teams/domain/entities/app_team.dart';
import 'package:smart_cricket_scorer/core/config/app_theme.dart';
import 'package:uuid/uuid.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Easy Cricket Scorer')),
      body: teamsAsync.when(
        data: (teams) {
          if (teams.isEmpty) return const Center(child: Text("No teams found."));
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
                  onTap: () => context.push('/teams/${team.teamId}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Team'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Team Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.isEmpty) return;
              final team = AppTeam(
                teamId: const Uuid().v4(),
                teamName: ctrl.text.trim(),
                createdBy: 'dummy-user-id',
              );
              await ref.read(teamRepositoryProvider).createTeam(team);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
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
