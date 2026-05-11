import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/models/sport_model.dart';

class SportDashboardScreen extends StatefulWidget {
  const SportDashboardScreen({
    super.key,
    required this.sport,
    required this.sportId,
    required this.selectedFormat,
  });

  final SportModel sport;
  final String sportId;
  final String selectedFormat;

  @override
  State<SportDashboardScreen> createState() => _SportDashboardScreenState();
}

class _SportDashboardScreenState extends State<SportDashboardScreen> {
  static const List<String> _formats = <String>[
    'Singles',
    'Doubles',
    'Best of 3 Sets (21 points)',
  ];

  late String _selectedFormat;

  @override
  void initState() {
    super.initState();
    _selectedFormat = _formats.contains(widget.selectedFormat)
        ? widget.selectedFormat
        : 'Singles';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.sport.displayName} Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: widget.sport.accentColor.withValues(
                        alpha: 0.16,
                      ),
                      child: Icon(
                        widget.sport.icon,
                        color: widget.sport.accentColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.sport.displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Format: $_selectedFormat',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RadioGroup<String>(
                  groupValue: _selectedFormat,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() => _selectedFormat = value);
                  },
                  child: Column(
                    children: _formats.map((format) {
                      return RadioListTile<String>(
                        value: format,
                        title: Text(format),
                        subtitle: format == 'Best of 3 Sets (21 points)'
                            ? const Text('First to two sets, 21 points per set')
                            : null,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _startMatch,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Match'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                context.push('/badminton-history');
              },
              icon: const Icon(Icons.history),
              label: const Text('View Badminton History'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startMatch() {
    context.push(
      '/badminton-match-create',
      extra: <String, dynamic>{
        'sport': widget.sport,
        'sportId': widget.sportId,
        'selectedFormat': _selectedFormat,
      },
    );
  }
}
