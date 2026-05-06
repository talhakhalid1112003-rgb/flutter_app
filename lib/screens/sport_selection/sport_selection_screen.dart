import 'package:flutter/material.dart';

class SportSelectionScreen extends StatelessWidget {
  const SportSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Sport')),
      body: const Center(child: Text('Sport selection screen')),
    );
  }
}
