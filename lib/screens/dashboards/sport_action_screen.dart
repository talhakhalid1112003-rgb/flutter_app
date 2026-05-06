import 'package:flutter/material.dart';

class DashboardActionData {
  const DashboardActionData({
    required this.title,
    this.description,
  });

  final String title;
  final String? description;
}

class SportActionScreen extends StatelessWidget {
  const SportActionScreen({
    super.key,
    required this.action,
  });

  final DashboardActionData action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(action.title)),
      body: Center(child: Text(action.description ?? 'No description available')),
    );
  }
}
