class BadmintonMatch {
  BadmintonMatch({
    this.team1Name = 'Team A',
    this.team2Name = 'Team B',
    this.selectedFormat = 'Singles',
    this.team1Score = 0,
    this.team2Score = 0,
    this.team1Sets = 0,
    this.team2Sets = 0,
    this.currentSet = 1,
  });

  final String team1Name;
  final String team2Name;
  final String selectedFormat;

  int team1Score;
  int team2Score;
  int team1Sets;
  int team2Sets;
  int currentSet;
  int _twentyTwentyResetCount = 0;
  bool _suddenDeathAtTwenty = false;

  final List<_BadmintonSnapshot> _history = <_BadmintonSnapshot>[];

  bool get isMatchOver => team1Sets >= 2 || team2Sets >= 2;

  String? get winner {
    if (team1Sets >= 2) {
      return team1Name;
    }
    if (team2Sets >= 2) {
      return team2Name;
    }
    return null;
  }

  bool scoreTeam1() {
    if (isMatchOver) {
      return false;
    }

    _pushHistory();
    team1Score += 1;
    _checkSetWin();
    return true;
  }

  bool scoreTeam2() {
    if (isMatchOver) {
      return false;
    }

    _pushHistory();
    team2Score += 1;
    _checkSetWin();
    return true;
  }

  bool undoLastPoint() {
    if (_history.isEmpty) {
      return false;
    }

    final last = _history.removeLast();
    team1Score = last.team1Score;
    team2Score = last.team2Score;
    team1Sets = last.team1Sets;
    team2Sets = last.team2Sets;
    currentSet = last.currentSet;
    _twentyTwentyResetCount = last.twentyTwentyResetCount;
    _suddenDeathAtTwenty = last.suddenDeathAtTwenty;
    return true;
  }

  void resetMatch() {
    team1Score = 0;
    team2Score = 0;
    team1Sets = 0;
    team2Sets = 0;
    currentSet = 1;
    _twentyTwentyResetCount = 0;
    _suddenDeathAtTwenty = false;
    _history.clear();
  }

  void _pushHistory() {
    _history.add(
      _BadmintonSnapshot(
        team1Score: team1Score,
        team2Score: team2Score,
        team1Sets: team1Sets,
        team2Sets: team2Sets,
        currentSet: currentSet,
        twentyTwentyResetCount: _twentyTwentyResetCount,
        suddenDeathAtTwenty: _suddenDeathAtTwenty,
      ),
    );
  }

  void _checkSetWin() {
    if (team1Score == 20 && team2Score == 20) {
      if (_twentyTwentyResetCount < 3) {
        _twentyTwentyResetCount += 1;
        team1Score = 18;
        team2Score = 18;
        return;
      }

      _suddenDeathAtTwenty = true;
      return;
    }

    final difference = (team1Score - team2Score).abs();

    final team1WonSet =
        team1Score == 30 ||
        (_suddenDeathAtTwenty && team1Score == 21 && team1Score > team2Score) ||
        (team1Score >= 21 && difference >= 2 && team1Score > team2Score);
    final team2WonSet =
        team2Score == 30 ||
        (_suddenDeathAtTwenty && team2Score == 21 && team2Score > team1Score) ||
        (team2Score >= 21 && difference >= 2 && team2Score > team1Score);

    if (!team1WonSet && !team2WonSet) {
      return;
    }

    if (team1WonSet) {
      team1Sets += 1;
    } else {
      team2Sets += 1;
    }

    if (!isMatchOver) {
      currentSet += 1;
    }

    // A set has been completed, so points reset for the next set.
    team1Score = 0;
    team2Score = 0;
    _twentyTwentyResetCount = 0;
    _suddenDeathAtTwenty = false;
  }
}

class _BadmintonSnapshot {
  const _BadmintonSnapshot({
    required this.team1Score,
    required this.team2Score,
    required this.team1Sets,
    required this.team2Sets,
    required this.currentSet,
    required this.twentyTwentyResetCount,
    required this.suddenDeathAtTwenty,
  });

  final int team1Score;
  final int team2Score;
  final int team1Sets;
  final int team2Sets;
  final int currentSet;
  final int twentyTwentyResetCount;
  final bool suddenDeathAtTwenty;
}
