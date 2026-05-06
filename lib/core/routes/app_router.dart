import 'package:go_router/go_router.dart';
import 'package:scoring_app/core/presentation/pages/main_screen.dart';
import 'package:scoring_app/features/matches/presentation/pages/create_match_screen.dart';
import 'package:scoring_app/features/matches/presentation/pages/match_squad_screen.dart';
import 'package:scoring_app/features/tournaments/presentation/pages/tournaments_screen.dart';
import 'package:scoring_app/features/tournaments/presentation/pages/create_tournament_screen.dart';
import 'package:scoring_app/features/tournaments/presentation/pages/tournament_dashboard_screen.dart';
import 'package:scoring_app/features/teams/presentation/pages/teams_screen.dart';
import 'package:scoring_app/features/teams/presentation/pages/team_detail_screen.dart';
import 'package:scoring_app/features/matches/presentation/pages/match_history_screen.dart';
import 'package:scoring_app/features/scoring/presentation/pages/live_scoring_screen.dart';
import 'package:scoring_app/features/scoring/presentation/pages/partnership_screen.dart';
final appRouter = GoRouter(
  initialLocation: '/new-match',
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
                return CreateMatchScreen(tournamentId: tournamentId);
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
                    return TeamDetailScreen(teamId: state.pathParameters['id']!);
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
      path: '/create-tournament',
      builder: (context, state) => const CreateTournamentScreen(),
    ),
    GoRoute(
      path: '/tournament-dashboard/:id',
      builder: (context, state) {
        return TournamentDashboardScreen(tournamentId: state.pathParameters['id']!);
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
  ],
);
