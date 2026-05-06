import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cricket_scorer/features/teams/presentation/providers/player_providers.dart';
import 'package:smart_cricket_scorer/features/teams/domain/entities/app_player.dart';
import 'package:uuid/uuid.dart';

class TeamDetailScreen extends ConsumerWidget {
  final String teamId;
  const TeamDetailScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersByTeamProvider(teamId));

    return Scaffold(
      appBar: AppBar(title: const Text('Players')),
      body: playersAsync.when(
        data: (players) {
          if (players.isEmpty) return const Center(child: Text("No players added."));
          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return ListTile(
                title: Text(player.playerName),
                subtitle: Text('${player.role} - \u26BE ${player.battingStyle} - \u26BD ${player.bowlingStyle}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlayerDialog(context, ref, teamId),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddPlayerDialog(BuildContext context, WidgetRef ref, String teamId) {
    final nameCtrl = TextEditingController();
    String role = 'Batter';
    String batStyle = 'Right Hand';
    String bowlStyle = 'Right Arm Medium';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Player'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Player Name')),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  items: ['Batter', 'Bowler', 'All-Rounder', 'Wicket Keeper'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => role = v!),
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: batStyle,
                  items: ['Right Hand', 'Left Hand'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => batStyle = v!),
                  decoration: const InputDecoration(labelText: 'Batting Style'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: bowlStyle,
                  items: ['Right Arm Fast', 'Right Arm Medium', 'Right Arm Spin', 'Left Arm Fast', 'Left Arm Medium', 'Left Arm Spin'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => bowlStyle = v!),
                  decoration: const InputDecoration(labelText: 'Bowling Style'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty) return;
                final player = AppPlayer(
                  playerId: const Uuid().v4(),
                  playerName: nameCtrl.text.trim(),
                  teamId: teamId,
                  role: role,
                  battingStyle: batStyle,
                  bowlingStyle: bowlStyle,
                );
                await ref.read(playerRepositoryProvider).addPlayer(player);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
