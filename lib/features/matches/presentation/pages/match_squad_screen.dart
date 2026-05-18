import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/features/matches/presentation/providers/match_providers.dart';
import 'package:scoring_app/features/teams/presentation/providers/player_providers.dart';
import 'package:scoring_app/features/teams/domain/entities/app_player.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:uuid/uuid.dart';

class MatchSquadScreen extends ConsumerWidget {
  final String matchId;
  final String inningsId;

  const MatchSquadScreen({
    super.key,
    required this.matchId,
    required this.inningsId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);

    return matchesAsync.when(
      data: (matches) {
        final matchOpt = matches.where((m) => m.matchId == matchId).toList();
        if (matchOpt.isEmpty) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text("Match not found")));
        }
        final match = matchOpt.first;

        final teamAAsync = ref.watch(playersByTeamProvider(match.teamAId!));
        final teamBAsync = ref.watch(playersByTeamProvider(match.teamBId!));

        int teamACount = teamAAsync.maybeWhen(data: (p) => p.length, orElse: () => 0);
        int teamBCount = teamBAsync.maybeWhen(data: (p) => p.length, orElse: () => 0);
        bool canStart = teamACount == 11 && teamBCount == 11;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/new-match');
                  }
                },
              ),
              title: const Text('Add Squad Players'),
              bottom: TabBar(
                indicatorColor: AppTheme.primaryBlue,
                labelColor: AppTheme.primaryBlue,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: '${match.teamAName} ($teamACount/11)'),
                  Tab(text: '${match.teamBName} ($teamBCount/11)'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _TeamSquadTab(teamId: match.teamAId!, teamName: match.teamAName),
                _TeamSquadTab(teamId: match.teamBId!, teamName: match.teamBName),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (canStart) {
                    context.go('/scoring/$matchId/$inningsId');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Both teams must have exactly 11 players. (Team A: $teamACount, Team B: $teamBCount)')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  backgroundColor: canStart ? AppTheme.primaryBlue : Colors.grey.shade800,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Start Match'),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}

class _TeamSquadTab extends ConsumerStatefulWidget {
  final String teamId;
  final String teamName;

  const _TeamSquadTab({required this.teamId, required this.teamName});

  @override
  ConsumerState<_TeamSquadTab> createState() => _TeamSquadTabState();
}

class _TeamSquadTabState extends ConsumerState<_TeamSquadTab> {
  final _nameCtrl = TextEditingController();
  String _selectedRole = 'Batter';
  final List<String> _roles = ['Batter', 'Bowler', 'All Rounder', 'Batter and Keeper'];

  void _addPlayer() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    final newPlayer = AppPlayer(
      playerId: const Uuid().v4(),
      playerName: name,
      teamId: widget.teamId,
      role: _selectedRole, 
      battingStyle: 'Right Hand',
      bowlingStyle: 'Right Arm Fast',
    );

    try {
      await ref.read(playerRepositoryProvider).addPlayer(newPlayer);
      _nameCtrl.clear();
      setState(() {
        _selectedRole = 'Batter';
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(playersByTeamProvider(widget.teamId));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Column(
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Player Name',
                  hintText: 'Enter name to add to ${widget.teamName}',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      items: _roles.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _selectedRole = v);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _addPlayer,
                    icon: const Icon(Icons.add_circle),
                    color: AppTheme.primaryBlue,
                    iconSize: 40,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: playersAsync.when(
              data: (players) {
                if (players.isEmpty) return const Center(child: Text("No players added yet.", style: TextStyle(color: Colors.grey)));
                return ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Card(
                      color: AppTheme.cardColorDark,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppTheme.primaryBlue,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(player.playerName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(player.role, style: const TextStyle(color: Colors.grey)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref.read(playerRepositoryProvider).removePlayer(player.playerId);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          )
        ],
      ),
    );
  }
}
