# COMPLETE UPDATED CODE - Key Sections

## 1. BadmintonTeamService - New Methods

```dart
/// Fetch all badminton teams from Firestore (for dropdown selection in doubles mode)
Future<List<BadmintonTeamModel>> fetchAllTeams() async {
  try {
    final snapshot = await _firestore
        .collection(collectionName)
        .get();
    
    final teams = snapshot.docs
        .map((doc) => BadmintonTeamModel.fromMap(doc.data()))
        .toList();
    
    // Sort by creation date (newest first)
    teams.sort(
      (left, right) => right.createdAt.compareTo(left.createdAt),
    );
    
    return teams;
  } catch (e) {
    throw Exception('Failed to fetch badminton teams: $e');
  }
}

/// Stream all badminton teams from Firestore (for real-time updates)
Stream<List<BadmintonTeamModel>> streamAllTeams() {
  return _firestore
      .collection(collectionName)
      .snapshots()
      .map((snapshot) {
        final teams = snapshot.docs
            .map((doc) => BadmintonTeamModel.fromMap(doc.data()))
            .toList();
        teams.sort(
          (left, right) => right.createdAt.compareTo(left.createdAt),
        );
        return teams;
      });
}

/// Get a specific team by ID
Future<BadmintonTeamModel?> getTeamById(String teamId) async {
  try {
    final doc = await _firestore
        .collection(collectionName)
        .doc(teamId)
        .get();
    
    if (doc.exists && doc.data() != null) {
      return BadmintonTeamModel.fromMap(doc.data()!);
    }
    return null;
  } catch (e) {
    throw Exception('Failed to fetch team: $e');
  }
}
```

---

## 2. BadmintonMatchCreateScreen - State Updates

```dart
class _BadmintonMatchCreateScreenState
    extends State<BadmintonMatchCreateScreen> {
  static const int _currentIndex = 0;
  static const List<int> _pointsOptions = <int>[11, 15, 21];

  final BadmintonHistoryService _historyService = BadmintonHistoryService(
    FirebaseFirestore.instance,
  );

  final BadmintonTeamService _teamService = BadmintonTeamService(
    FirebaseFirestore.instance,
  );

  final _singlePlayerAController = TextEditingController();
  final _singlePlayerBController = TextEditingController();

  // Doubles mode team selection
  BadmintonTeamModel? _selectedTeamA;
  BadmintonTeamModel? _selectedTeamB;

  String _matchType = 'Singles';
  int _selectedPoints = 21;
  bool _saving = false;

  @override
  void dispose() {
    _singlePlayerAController.dispose();
    _singlePlayerBController.dispose();
    super.dispose();
  }
  // ... rest of implementation
}
```

---

## 3. StreamBuilder with Team Dropdown

```dart
Widget _buildDoublesTeamSelection() {
  return StreamBuilder<List<BadmintonTeamModel>>(
    stream: _teamService.streamAllTeams(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Error loading teams: ${snapshot.error}',
            style: const TextStyle(color: Colors.redAccent),
          ),
        );
      }

      final teams = snapshot.data ?? <BadmintonTeamModel>[];

      if (teams.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'No teams available. Please create teams first.',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Team A Dropdown
          _buildTeamDropdown(
            teamLabel: 'Team A',
            selectedTeam: _selectedTeamA,
            teams: teams,
            onChanged: (team) {
              setState(() {
                _selectedTeamA = team;
              });
            },
            isTeamBSelected: _selectedTeamB != null,
            selectedTeamB: _selectedTeamB,
          ),
          const SizedBox(height: 16),
          // Team A Players Display
          if (_selectedTeamA != null)
            _buildTeamPlayersDisplay(
              teamName: _selectedTeamA!.teamName,
              players: _selectedTeamA!.players,
            ),
          if (_selectedTeamA != null) const SizedBox(height: 16),
          // Team B Dropdown
          _buildTeamDropdown(
            teamLabel: 'Team B',
            selectedTeam: _selectedTeamB,
            teams: teams,
            onChanged: (team) {
              setState(() {
                _selectedTeamB = team;
              });
            },
            isTeamBSelected: true,
            selectedTeamA: _selectedTeamA,
          ),
          const SizedBox(height: 16),
          // Team B Players Display
          if (_selectedTeamB != null)
            _buildTeamPlayersDisplay(
              teamName: _selectedTeamB!.teamName,
              players: _selectedTeamB!.players,
            ),
        ],
      );
    },
  );
}
```

---

## 4. Team Dropdown with Validation

```dart
Widget _buildTeamDropdown({
  required String teamLabel,
  required BadmintonTeamModel? selectedTeam,
  required List<BadmintonTeamModel> teams,
  required ValueChanged<BadmintonTeamModel?> onChanged,
  bool isTeamBSelected = false,
  BadmintonTeamModel? selectedTeamA,
  BadmintonTeamModel? selectedTeamB,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        teamLabel,
        style: const TextStyle(
          color: AppTheme.primaryBlue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<BadmintonTeamModel>(
        value: selectedTeam,
        onChanged: (team) {
          if (team != null) {
            onChanged(team);
          }
        },
        items: teams
            .map(
              (team) => DropdownMenuItem<BadmintonTeamModel>(
                value: team,
                enabled: isTeamBSelected
                    ? team.teamId != selectedTeamA?.teamId
                    : team.teamId != selectedTeamB?.teamId,
                child: Opacity(
                  opacity: isTeamBSelected
                      ? team.teamId != selectedTeamA?.teamId
                          ? 1.0
                          : 0.5
                      : team.teamId != selectedTeamB?.teamId
                          ? 1.0
                          : 0.5,
                  child: Text(team.teamName),
                ),
              ),
            )
            .toList(),
        decoration: InputDecoration(
          hintText: 'Select $teamLabel',
          filled: true,
          fillColor: AppTheme.cardColorDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white24),
          ),
        ),
        dropdownColor: AppTheme.cardColorDark,
        style: const TextStyle(color: Colors.white),
      ),
      if (selectedTeam != null &&
          teamLabel == 'Team A' &&
          selectedTeamB != null &&
          selectedTeam.teamId == selectedTeamB!.teamId)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Same team cannot be selected twice',
            style: TextStyle(color: Colors.red[400], fontSize: 12),
          ),
        ),
    ],
  );
}
```

---

## 5. Player Display Widget

```dart
Widget _buildTeamPlayersDisplay({
  required String teamName,
  required List<String> players,
}) {
  return Card(
    color: AppTheme.cardColorDark.withValues(alpha: 0.5),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$teamName Players',
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...players
              .asMap()
              .entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    ),
  );
}
```

---

## 6. Updated Match Initialization (Doubles Mode)

```dart
BadmintonMatchModel? _buildInitialMatch(String userId) {
  if (_matchType == 'Singles') {
    final playerA = _singlePlayerAController.text.trim();
    final playerB = _singlePlayerBController.text.trim();
    if (playerA.isEmpty || playerB.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both player names.')),
      );
      return null;
    }

    return BadmintonMatchModel(
      matchId: '',
      userId: userId,
      matchType: _matchType,
      selectedPoints: _selectedPoints,
      teamAName: '',
      teamBName: '',
      players: <String, List<String>>{
        'teamA': <String>[playerA],
        'teamB': <String>[playerB],
      },
      scores: <String, int>{'teamA': 0, 'teamB': 0},
      roundsWon: <String, int>{'teamA': 0, 'teamB': 0},
      finalWinner: '',
      createdAt: DateTime.now(),
      matchStatus: 'live',
      currentRound: 1,
      deuceTieCount: 0,
      suddenDeathActive: false,
      roundSummaries: const <BadmintonRoundSummary>[],
    );
  }

  // Doubles mode
  if (_selectedTeamA == null || _selectedTeamB == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select both Team A and Team B.')),
    );
    return null;
  }

  // Validation: Same team cannot be selected twice
  if (_selectedTeamA!.teamId == _selectedTeamB!.teamId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Team A and Team B must be different teams.'),
      ),
    );
    return null;
  }

  return BadmintonMatchModel(
    matchId: '',
    userId: userId,
    matchType: _matchType,
    selectedPoints: _selectedPoints,
    teamAName: _selectedTeamA!.teamName,
    teamBName: _selectedTeamB!.teamName,
    players: <String, List<String>>{
      'teamA': _selectedTeamA!.players,
      'teamB': _selectedTeamB!.players,
    },
    scores: <String, int>{'teamA': 0, 'teamB': 0},
    roundsWon: <String, int>{'teamA': 0, 'teamB': 0},
    finalWinner: '',
    createdAt: DateTime.now(),
    matchStatus: 'live',
    currentRound: 1,
    deuceTieCount: 0,
    suddenDeathActive: false,
    roundSummaries: const <BadmintonRoundSummary>[],
  );
}
```

---

## Import Statements Required

```dart
// In BadmintonMatchCreateScreen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_round_summary.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_team_model.dart'; // NEW
import 'package:scoring_app/features/badminton/data/services/badminton_history_service.dart';
import 'package:scoring_app/features/badminton/data/services/badminton_team_service.dart'; // NEW
import 'package:scoring_app/features/badminton/presentation/widgets/badminton_bottom_navigation_bar.dart';
```

---

## Validation Rules

### When Creating Doubles Match:

1. **Validation 1**: Both teams must be selected
   - Message: "Please select both Team A and Team B."
   - Returns: null (null-coalescing on _selectedTeamA and _selectedTeamB)

2. **Validation 2**: Teams must be different
   - Message: "Team A and Team B must be different teams."
   - Check: `_selectedTeamA!.teamId == _selectedTeamB!.teamId`

3. **UI Validation**: Dropdown disables duplicate team
   - Team B dropdown disables Team A if already selected
   - Team A dropdown disables Team B if already selected
   - Shows error text if same team selected

---

## Data Passed to BadmintonMatchScreen

From Doubles Team Selection:

```dart
BadmintonMatchModel(
  // ... other fields ...
  teamAName: _selectedTeamA!.teamName,        // "NTU"
  teamBName: _selectedTeamB!.teamName,        // "PU"
  players: {
    'teamA': _selectedTeamA!.players,         // ["Talha", "Ali"]
    'teamB': _selectedTeamB!.players,         // ["Hassan", "Umer"]
  },
  // ... other fields ...
)
```

All data comes directly from Firestore `Badminton_Teams` collection.

---

## Architecture Summary

```
┌─────────────────────────────────────────────┐
│     BadmintonMatchCreateScreen (UI)         │
│   - Singles: Manual text input              │
│   - Doubles: Team dropdown selection        │
└─────────────────┬───────────────────────────┘
                  │ uses
┌─────────────────▼───────────────────────────┐
│   BadmintonTeamService (Service Layer)      │
│   - fetchAllTeams()                         │
│   - streamAllTeams() ← Used by UI           │
│   - getTeamById()                           │
└─────────────────┬───────────────────────────┘
                  │ fetches from
┌─────────────────▼───────────────────────────┐
│ Firestore Database                          │
│ Collection: Badminton_Teams                 │
│ Fields: teamId, teamName, players, etc.     │
└─────────────────────────────────────────────┘
```

All changes maintain Clean Architecture principles and Null Safety.
