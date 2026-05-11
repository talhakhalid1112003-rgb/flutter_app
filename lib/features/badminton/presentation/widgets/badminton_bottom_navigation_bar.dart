import 'package:flutter/material.dart';

class BadmintonBottomNavigationBar extends StatelessWidget {
  const BadmintonBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_tennis),
          label: 'New Match',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Tournament',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Teams'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
      ],
    );
  }
}
