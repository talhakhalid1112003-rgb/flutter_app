import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/config/app_theme.dart';
import 'package:scoring_app/core/routes/app_router.dart';
import 'package:scoring_app/models/sport_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Update the initialization code
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }

  final preferences = await SharedPreferences.getInstance();
  final savedSport = preferences.getString(SportModel.selectedSportKey);
  final initialLocation = savedSport == null
      ? AppRoutes.sportSelection
      : SportModel.fromStorageValue(savedSport).routePath;

  final GoRouter router = createAppRouter(initialLocation: initialLocation);

  runApp(ProviderScope(child: MyApp(routerConfig: router)));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.routerConfig});

  final GoRouter routerConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Smart Cricket Scorer',
      theme: AppTheme.darkTheme,
      routerConfig: routerConfig,
    );
  }
}
