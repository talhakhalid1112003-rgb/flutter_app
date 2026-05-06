import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Cricket Scorer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Adjust UI mode'),
              trailing: const Icon(Icons.brightness_4),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Remove ad'),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Clear all data', style: TextStyle(color: Colors.deepOrange)),
              trailing: const Icon(Icons.delete_sweep, color: Colors.deepOrange),
              onTap: () => _clearAllData(context),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Help', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Rate us'),
                  subtitle: const Text('Rate us and use our apps'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Share this app'),
                  subtitle: const Text('Share the app to your friends'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Feedback'),
                  subtitle: const Text('Report bugs and tell us what to improve'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('See the app on Play store'),
                  trailing: const Icon(Icons.play_arrow, color: Colors.green),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Privacy policy'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Version 2.1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllData(BuildContext context) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure you want to delete all matches, teams, innings, and players? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      )
    );

    if (confirm == true) {
      if (!context.mounted) return;
      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
      
      try {
        final firestore = FirebaseFirestore.instance;
        final batches = <WriteBatch>[];
        var currentBatch = firestore.batch();
        int opCount = 0;

        Future<void> deleteCollection(String path) async {
          final snapshot = await firestore.collection(path).get();
          for (var doc in snapshot.docs) {
            currentBatch.delete(doc.reference);
            opCount++;
            if (opCount >= 450) {
              batches.add(currentBatch);
              currentBatch = firestore.batch();
              opCount = 0;
            }
          }
        }

        await deleteCollection('matches');
        await deleteCollection('teams');
        await deleteCollection('players');
        await deleteCollection('innings');

        if (opCount > 0) batches.add(currentBatch);
        for (var b in batches) {
          await b.commit();
        }

        if (context.mounted) {
          Navigator.pop(context); 
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared successfully!')));
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); 
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error clearing data: $e')));
        }
      }
    }
  }
}
