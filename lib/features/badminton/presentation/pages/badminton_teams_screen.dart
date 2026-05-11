import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_team_service.dart';
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';

class BadmintonTeamsScreen extends StatefulWidget {
  const BadmintonTeamsScreen({super.key});

  @override
  State<BadmintonTeamsScreen> createState() => _BadmintonTeamsScreenState();
}

class _BadmintonTeamsScreenState extends State<BadmintonTeamsScreen> {
  static const int _currentIndex = 2;

  final BadmintonTeamService _service = BadmintonTeamService(
    FirebaseFirestore.instance,
  );
  final _formKey = GlobalKey<FormState>();
  final _teamANameController = TextEditingController();
  final _teamBNameController = TextEditingController();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  final _player3Controller = TextEditingController();
  final _player4Controller = TextEditingController();
  final _singlePlayerAController = TextEditingController();
  final _singlePlayerBController = TextEditingController();

  String _teamType = 'Singles';
  bool _saving = false;

  @override
  void dispose() {
    _teamANameController.dispose();
    _teamBNameController.dispose();
    _player1Controller.dispose();
    _player2Controller.dispose();
    _player3Controller.dispose();
    _player4Controller.dispose();
    _singlePlayerAController.dispose();
    _singlePlayerBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Badminton Teams')),
      bottomNavigationBar: BadmintonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _goToIndex(context, index),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppTheme.cardColorDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Save badminton players for singles and doubles separately.',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: AppTheme.cardColorDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildModeToggle('Singles'),
                    const SizedBox(height: 12),
                    _buildModeToggle('Doubles'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Card(
                color: AppTheme.cardColorDark,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _teamType == 'Singles'
                        ? [
                            TextFormField(
                              controller: _singlePlayerAController,
                              decoration: const InputDecoration(
                                labelText: 'Player A Name',
                              ),
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _singlePlayerBController,
                              decoration: const InputDecoration(
                                labelText: 'Player B Name',
                              ),
                              validator: _requiredValidator,
                            ),
                          ]
                        : [
                            TextFormField(
                              controller: _teamANameController,
                              decoration: const InputDecoration(
                                labelText: 'Team A Name',
                              ),
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _player1Controller,
                              decoration: const InputDecoration(
                                labelText: 'Team A - Player 1',
                              ),
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _player2Controller,
                              decoration: const InputDecoration(
                                labelText: 'Team A - Player 2',
                              ),
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _teamBNameController,
                              decoration: const InputDecoration(
                                labelText: 'Team B Name',
                              ),
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _player3Controller,
                              decoration: const InputDecoration(
                                labelText: 'Team B - Player 1',
                              ),
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _player4Controller,
                              decoration: const InputDecoration(
                                labelText: 'Team B - Player 2',
                              ),
                              validator: _requiredValidator,
                            ),
                          ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saving ? null : () => _saveTeam(userId),
              icon: const Icon(Icons.save),
              label: Text(_saving ? 'Saving...' : 'Save Team'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saved Teams',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (userId == null)
              const Card(
                color: AppTheme.cardColorDark,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Sign in to manage badminton teams.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              )
            else
              StreamBuilder<List<BadmintonTeamModel>>(
                stream: _service.watchUserTeams(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Card(
                      color: AppTheme.cardColorDark,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Failed to load teams: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final teams = snapshot.data ?? <BadmintonTeamModel>[];
                  if (teams.isEmpty) {
                    return Card(
                      color: AppTheme.cardColorDark,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No badminton teams saved yet.',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: teams
                        .map(
                          (team) => Card(
                            color: AppTheme.cardColorDark,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          team.teamType,
                                          style: const TextStyle(
                                            color: AppTheme.primaryBlue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        team.teamName,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: team.players
                                        .map(
                                          (player) => Chip(label: Text(player)),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle(String value) {
    final selected = _teamType == value;
    return InkWell(
      onTap: () => setState(() => _teamType = value),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryBlue.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.primaryBlue : Colors.white24,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppTheme.primaryBlue : Colors.white54,
            ),
            const SizedBox(width: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  Future<void> _saveTeam(String? userId) async {
    if (userId == null) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _saving = true);
    try {
      final team = _teamType == 'Singles'
          ? BadmintonTeamModel(
              teamId: '',
              userId: userId,
              teamType: 'Singles',
              teamName:
                  '${_singlePlayerAController.text.trim()} & ${_singlePlayerBController.text.trim()}',
              players: [
                _singlePlayerAController.text.trim(),
                _singlePlayerBController.text.trim(),
              ],
              createdAt: DateTime.now(),
            )
          : BadmintonTeamModel(
              teamId: '',
              userId: userId,
              teamType: 'Doubles',
              teamName:
                  '${_teamANameController.text.trim()} vs ${_teamBNameController.text.trim()}',
              players: [
                _player1Controller.text.trim(),
                _player2Controller.text.trim(),
                _player3Controller.text.trim(),
                _player4Controller.text.trim(),
              ],
              createdAt: DateTime.now(),
            );
      await _service.saveTeam(team);
      if (!mounted) {
        return;
      }
      _formKey.currentState?.reset();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Badminton team saved.')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save team: $e')));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _goToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/badminton/create');
        return;
      case 1:
        context.go('/badminton/tournament');
        return;
      case 2:
        return;
      case 3:
        context.go('/badminton/history');
        return;
    }
  }
}
