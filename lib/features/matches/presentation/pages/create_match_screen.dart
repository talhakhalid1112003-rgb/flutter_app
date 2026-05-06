import 'package:flutter/material.dart';

class CreateMatchScreen extends StatelessWidget {
  const CreateMatchScreen({super.key, required this.sportId});

  final String sportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Match')),
      body: Center(child: Text('Create match for: $sportId')),
    );
  }
}
