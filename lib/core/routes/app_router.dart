import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoring_app/core/presentation/pages/main_screen.dart';
import 'package:scoring_app/features/matches/presentation/pages/create_match_screen.dart';
import 'package:scoring_app/features/matches/presentation/pages/match_squad_screen.dart';
import 'package:scoring_app/features/tournaments/presentation/pages/tournaments_screen.dart';
import 'package:scoring_app/features/tournaments/presentation/pages/create_tournament_screen.dart';
import 'package:scoring_app/features/tournaments/presentation/pages/tournament_dashboard_screen.dart';
import 'package:scoring_app/features/teams/presentation/pages/teams_screen.dart';
import 'package:scoring_app/features/teams/presentation/pages/team_detail_screen.dart';
import 'package:scoring_app/features/matches/presentation/pages/match_history_screen.dart';
import 'package:scoring_app/features/sport_selection/presentation/pages/sport_selection_screen.dart';
import 'package:scoring_app/features/scoring/presentation/pages/live_scoring_screen.dart';
import 'package:scoring_app/features/scoring/presentation/pages/partnership_screen.dart';
import 'package:scoring_app/features/auth/screens/login_screen.dart';
import 'package:scoring_app/features/auth/screens/forgot_password_screen.dart';
import 'package:scoring_app/features/auth/screens/reset_password_success_screen.dart';
import 'package:scoring_app/features/auth/screens/signup_screen.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_match_model.dart';
import 'package:scoring_app/features/badminton/data/models/badminton_tournament_model.dart';
import 'package:scoring_app/features/badminton/presentation/pages/badminton_history_screen.dart';
import 'package:scoring_app/features/badminton/presentation/pages/badminton_tournament_details_screen.dart';
import 'package:scoring_app/features/badminton/presentation/pages/badminton_match_create_screen.dart';
import 'package:scoring_app/features/badminton/presentation/pages/badminton_match_screen.dart';
import 'package:scoring_app/features/badminton/presentation/pages/badminton_tournament_match_screen.dart';
import 'package:scoring_app/features/badminton/presentation/pages/badminton_teams_screen.dart';
import 'package:scoring_app/features/badminton/presentation/pages/badminton_tournament_screen.dart';

bool isPublicAuthRoute(String path) {
  return path == '/login' ||
      path == '/signup' ||
      path == '/forgot-password' ||
      path == '/reset-password-success';
}

String? redirectForAuth(String path, bool isLoggedIn) {
  if (!isLoggedIn) {
    return isPublicAuthRoute(path) ? null : '/login';
  }

  if (path == '/login' || path == '/signup' || path == '/') {
    return '/sport-selection';
  }

  return null;
}

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    return redirectForAuth(state.uri.path, isLoggedIn);
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/new-match',
              builder: (context, state) {
                final tournamentId = state.extra as String?;
                final sportId = state.uri.queryParameters['sportId'];
                final teamFormat = state.uri.queryParameters['teamFormat'];
                return CreateMatchScreen(
                  tournamentId: tournamentId,
                  sportId: sportId,
                  teamFormat: teamFormat,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tournaments',
              builder: (context, state) => const TournamentsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/teams',
              builder: (context, state) => const TeamsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    return TeamDetailScreen(
                      teamId: state.pathParameters['id']!,
                      sportId:
                          state.uri.queryParameters['sportId'] ?? 'cricket',
                      selectedFormat:
                          state.uri.queryParameters['selectedFormat'],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const MatchHistoryScreen(),
            ),
          ],
        ),
      ],
    ),
    // Scoring screen, squad screen, and tournament screens are outside the bottom nav
    GoRoute(
      path: '/sport-selection',
      builder: (context, state) => const SportSelectionScreen(),
    ),
    GoRoute(
      path: '/badminton/create',
      builder: (context, state) => const BadmintonMatchCreateScreen(),
    ),
    GoRoute(
      path: '/badminton/tournament',
      builder: (context, state) => const BadmintonTournamentScreen(),
    ),
    GoRoute(
      path: '/badminton/tournament/match',
      builder: (context, state) {
        final tournament = state.extra is BadmintonTournamentModel
            ? state.extra as BadmintonTournamentModel
            : null;
        if (tournament == null) {
          return const Scaffold(
            body: Center(child: Text('Tournament session missing.')),
          );
        }
        return BadmintonTournamentMatchScreen(tournament: tournament);
      },
    ),
    GoRoute(
      path: '/badminton/teams',
      builder: (context, state) => const BadmintonTeamsScreen(),
    ),
    GoRoute(
      path: '/badminton/history',
      builder: (context, state) {
        return BadmintonHistoryScreen(
          initialTabIndex:
              state.uri.queryParameters['tab'] == 'tournament' ? 1 : 0,
        );
      },
    ),
    GoRoute(
      path: '/badminton/tournament-history',
      builder: (context, state) => BadmintonHistoryScreen(
        initialTabIndex: state.uri.queryParameters['tab'] == 'tournament' ? 1 : 0,
      ),
    ),
    GoRoute(
      path: '/badminton/tournament-history/:tournamentId',
      builder: (context, state) {
        return BadmintonTournamentDetailsScreen(
          tournamentId: state.pathParameters['tournamentId']!,
        );
      },
    ),
    GoRoute(
      path: '/badminton/match/:matchId',
      builder: (context, state) {
        final extra = state.extra;
        return BadmintonMatchScreen(
          matchId: state.pathParameters['matchId']!,
          initialMatch: extra is BadmintonMatchModel ? extra : null,
        );
      },
    ),
    GoRoute(
      path: '/badminton-match-score/:matchId',
      builder: (context, state) {
        return BadmintonMatchScreen(
          matchId: state.pathParameters['matchId']!,
          initialMatch: state.extra is BadmintonMatchModel
              ? state.extra as BadmintonMatchModel
              : null,
        );
      },
    ),
    GoRoute(
      path: '/dashboard/badminton',
      builder: (context, state) => const BadmintonMatchCreateScreen(),
    ),
    GoRoute(
      path: '/create-tournament',
      builder: (context, state) => const CreateTournamentScreen(),
    ),
    GoRoute(
      path: '/tournament-dashboard/:id',
      builder: (context, state) {
        return TournamentDashboardScreen(
          tournamentId: state.pathParameters['id']!,
        );
      },
    ),
    GoRoute(
      path: '/match-squad/:matchId/:inningsId',
      builder: (context, state) {
        return MatchSquadScreen(
          matchId: state.pathParameters['matchId']!,
          inningsId: state.pathParameters['inningsId']!,
        );
      },
    ),
    GoRoute(
      path: '/scoring/:matchId/:inningsId',
      builder: (context, state) {
        return LiveScoringScreen(
          matchId: state.pathParameters['matchId']!,
          inningsId: state.pathParameters['inningsId']!,
        );
      },
    ),
    GoRoute(
      path: '/partnership/:matchId/:inningsId',
      builder: (context, state) {
        return PartnershipScreen(
          matchId: state.pathParameters['matchId']!,
          inningsId: state.pathParameters['inningsId']!,
        );
      },
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) {
        final initialEmail = state.extra is String ? state.extra as String : null;
        return ForgotPasswordScreen(initialEmail: initialEmail);
      },
    ),
    GoRoute(
      path: '/reset-password-success',
      builder: (context, state) {
        final email = state.extra is String ? state.extra as String : null;
        return ResetPasswordSuccessScreen(email: email);
      },
    ),
  ],
);
