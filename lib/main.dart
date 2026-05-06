import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoring_app/core/routes/app_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Update the initialization code
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // TEMPORARY WIPE SCRIPT
    try {
      final firestore = FirebaseFirestore.instance;
      for (final col in ['matches', 'innings', 'teams', 'players', 'tournaments']) {
        final snap = await firestore.collection(col).get();
        for (final doc in snap.docs) {
          await doc.reference.delete();
        }
      }
      debugPrint("WIPED ALL DATA SUCCESSFULLY");
    } catch(e) {
      debugPrint("WIPE FAILED: $e");
    }
    
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Smart Cricket Scorer',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
