import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_tournament_model.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_team_service.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_tournament_history_service.dart';
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';

class BadmintonTournamentScreen extends StatefulWidget {
  const BadmintonTournamentScreen({super.key});

  @override
  State<BadmintonTournamentScreen> createState() => _BadmintonTournamentScreenState();
}

class _BadmintonTournamentScreenState extends State<BadmintonTournamentScreen> {
  static const int _currentIndex = 1;
  static const List<int> _pointOptions = <int>[11, 15, 21];

  final BadmintonTeamService _teamService = BadmintonTeamService(
    FirebaseFirestore.instance,
  );
  final BadmintonTournamentHistoryService _tournamentService =
      BadmintonTournamentHistoryService(FirebaseFirestore.instance);

  final Set<String> _selectedTeamIds = <String>{};
  bool _isLoading = true;
  bool _isStarting = false;
  String _matchType = 'Singles';
  int _pointToWin = 21;
  String? _errorMessage;
  List<BadmintonTeamModel> _teams = <BadmintonTeamModel>[];

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please sign in to create a badminton tournament.';
      });
      return;
    }

    try {
      final teams = await _teamService.fetchTeams(userId: user.uid);
      if (!mounted) return;
      setState(() {
        _teams = teams;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load badminton teams: $e';
      });
    }
  }

  List<BadmintonTeamModel> get _selectedTeams => _teams
      .where((team) => _selectedTeamIds.contains(team.id))
      .toList(growable: false);

  bool get _canStart => _selectedTeamIds.length == 4;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badminton Tournament'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/sport-selection');
            }
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Tournament History',
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/badminton/history?tab=tournament'),
          ),
        ],
      ),
      bottomNavigationBar: BadmintonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _goToIndex(context, index),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? _ErrorState(
                    message: _errorMessage!,
                    onRetry: _loadTeams,
                    onGoToTeams: () => context.go('/badminton/teams'),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(isWide ? 28 : 16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _SectionCard(
                              title: 'Tournament Settings',
                              subtitle:
                                  'Select match style, point target, and exactly four badminton teams.',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const _SectionLabel('Match Type'),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _ChoiceCard(
                                          label: 'Singles',
                                          subtitle: '1 player per side',
                                          selected: _matchType == 'Singles',
                                          onTap: () => setState(() => _matchType = 'Singles'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _ChoiceCard(
                                          label: 'Doubles',
                                          subtitle: '2 players per side',
                                          selected: _matchType == 'Doubles',
                                          onTap: () => setState(() => _matchType = 'Doubles'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const _SectionLabel('Point To Win'),
                                  const SizedBox(height: 8),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final width = constraints.maxWidth;
                                      final itemWidth = width >= 700 ? (width - 24) / 3 : width;
                                      return Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: _pointOptions.map((points) {
                                          return SizedBox(
                                            width: itemWidth,
                                            child: _ChoiceCard(
                                              label: '$points Points',
                                              subtitle: points == 21
                                                  ? 'Standard badminton set'
                                                  : points == 15
                                                      ? 'Medium format'
                                                      : 'Quick format',
                                              selected: _pointToWin == points,
                                              onTap: () => setState(() => _pointToWin = points),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              title: 'Team Selection',
                              trailing: Text(
                                'Selected Teams: ${_selectedTeamIds.length}/4',
                                style: const TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle:
                                  'Choose four unique teams from your Firestore badminton teams.',
                              child: Column(
                                children: [
                                  if (_teams.isEmpty)
                                    _EmptyTeamsState(
                                      onGoToTeams: () => context.go('/badminton/teams'),
                                    )
                                  else
                                    Container(
                                      constraints: const BoxConstraints(maxHeight: 520),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.03),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.08),
                                        ),
                                      ),
                                      child: ListView.separated(
                                        padding: const EdgeInsets.all(12),
                                        shrinkWrap: true,
                                        itemCount: _teams.length,
                                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                                        itemBuilder: (context, index) {
                                          final team = _teams[index];
                                          final isSelected = _selectedTeamIds.contains(team.id);
                                          final isDisabled = !isSelected && _selectedTeamIds.length >= 4;
                                          return _TeamCard(
                                            team: team,
                                            isSelected: isSelected,
                                            isDisabled: isDisabled,
                                            onTap: () => _toggleTeam(team.id),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              title: 'Bracket Preview',
                              subtitle:
                                  'Teams will be shuffled into semifinals and the winners will move to the final.',
                              child: _BracketPreview(selectedTeams: _selectedTeams),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _canStart && !_isStarting ? _startTournament : null,
                              icon: _isStarting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.emoji_events),
                              label: Text(
                                _isStarting ? 'Starting Tournament...' : 'Start Tournament',
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  void _toggleTeam(String teamId) {
    if (_selectedTeamIds.contains(teamId)) {
      setState(() => _selectedTeamIds.remove(teamId));
      return;
    }

    if (_selectedTeamIds.length >= 4) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('You can select only 4 teams.')));
      return;
    }

    setState(() => _selectedTeamIds.add(teamId));
  }

  Future<void> _startTournament() async {
    if (!_canStart || _isStarting) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('Please sign in to start a tournament.')));
      return;
    }

    setState(() => _isStarting = true);

    final selectedTeams = _selectedTeams;
    final draft = BadmintonTournamentModel(
      tournamentId: '',
      userId: user.uid,
      createdAt: DateTime.now(),
      matchType: _matchType,
      pointToWin: _pointToWin,
      selectedTeamIds: selectedTeams.map((team) => team.id).toList(growable: false),
      selectedTeams: selectedTeams,
      semifinal1: null,
      semifinal2: null,
      finalMatch: null,
      tournamentWinner: '',
      tournamentStatus: 'in_progress',
    );

    try {
      final savedTournament = await _tournamentService.saveTournament(draft);
      if (!mounted) {
        return;
      }
      context.push('/badminton/tournament/match', extra: savedTournament);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('Unable to start tournament: $e')));
      setState(() => _isStarting = false);
      return;
    }

    if (mounted) {
      setState(() => _isStarting = false);
    }
  }

  void _goToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/badminton/create');
        return;
      case 1:
        return;
      case 2:
        context.go('/badminton/teams');
        return;
      case 3:
        context.go('/badminton/history');
        return;
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final localTrailing = trailing;
    final localSubtitle = subtitle;
    
    return Card(
      color: AppTheme.cardColorDark,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (localSubtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          localSubtitle,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ],
                  ),
                ),
                if (localTrailing != null) localTrailing,
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.primaryBlue.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppTheme.primaryBlue : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: selected ? AppTheme.primaryBlue : Colors.white54,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.team,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final BadmintonTeamModel team;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = team.teamType == 'Singles'
        ? (team.players.isNotEmpty ? team.players.first : 'Player name pending')
        : (team.players.isNotEmpty ? team.players.join('  •  ') : 'Players pending');

    return Opacity(
      opacity: isDisabled ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryBlue.withValues(alpha: 0.14)
                  : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlue : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: isSelected
                      ? AppTheme.primaryBlue
                      : Colors.white.withValues(alpha: 0.08),
                  child: Text(
                    team.teamName.isNotEmpty ? team.teamName[0].toUpperCase() : 'T',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              team.teamName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppTheme.primaryBlue),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(subtitle, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BracketPreview extends StatelessWidget {
  const _BracketPreview({required this.selectedTeams});

  final List<BadmintonTeamModel> selectedTeams;

  @override
  Widget build(BuildContext context) {
    if (selectedTeams.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: const Text(
          'Select four teams to preview the tournament bracket.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final names = selectedTeams.map((team) => team.teamName).toList(growable: false);

    return Column(
      children: [
        _BracketRow(left: names.isNotEmpty ? names[0] : 'Team A', right: names.length > 1 ? names[1] : 'Team B', label: 'Semifinal 1'),
        const SizedBox(height: 10),
        _BracketConnector(),
        const SizedBox(height: 10),
        _BracketRow(left: names.length > 2 ? names[2] : 'Team C', right: names.length > 3 ? names[3] : 'Team D', label: 'Semifinal 2'),
        const SizedBox(height: 10),
        _BracketConnector(),
        const SizedBox(height: 10),
        const _ChampionPreview(),
      ],
    );
  }
}

class _BracketRow extends StatelessWidget {
  const _BracketRow({
    required this.left,
    required this.right,
    required this.label,
  });

  final String left;
  final String right;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(left, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Text('vs', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              right,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _BracketConnector extends StatelessWidget {
  const _BracketConnector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 2, color: Colors.white.withValues(alpha: 0.08))),
        Container(width: 2, height: 18, color: Colors.white.withValues(alpha: 0.08)),
        Expanded(child: Container(height: 2, color: Colors.white.withValues(alpha: 0.08))),
      ],
    );
  }
}

class _ChampionPreview extends StatelessWidget {
  const _ChampionPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.emoji_events, color: AppTheme.primaryBlue),
          SizedBox(width: 12),
          Text('Champion', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _EmptyTeamsState extends StatelessWidget {
  const _EmptyTeamsState({required this.onGoToTeams});

  final VoidCallback onGoToTeams;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          const Icon(Icons.people_outline, size: 56, color: Colors.white54),
          const SizedBox(height: 12),
          const Text(
            'No Teams Found',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create Teams First',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onGoToTeams,
            child: const Text('Go To Teams'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.onGoToTeams,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onGoToTeams;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Card(
            color: AppTheme.cardColorDark,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 56),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
                  const SizedBox(height: 10),
                  OutlinedButton(onPressed: onGoToTeams, child: const Text('Go To Teams')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
