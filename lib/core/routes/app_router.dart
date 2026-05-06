import 'package:go_router/go_router.dart';
import 'package:scoring_app/features/matches/presentation/pages/create_match_screen.dart';
import 'package:scoring_app/features/matches/presentation/pages/match_history_screen.dart';
import 'package:scoring_app/features/scoring/presentation/pages/live_scoring_screen.dart';
import 'package:scoring_app/features/teams/presentation/pages/team_detail_screen.dart';
import 'package:scoring_app/features/teams/presentation/pages/teams_screen.dart';
import 'package:scoring_app/screens/dashboards/badminton_dashboard.dart';
import 'package:scoring_app/screens/dashboards/cricket_dashboard.dart';
import 'package:scoring_app/screens/dashboards/football_dashboard.dart';
import 'package:scoring_app/screens/dashboards/sport_action_screen.dart';
import 'package:scoring_app/screens/dashboards/tennis_dashboard.dart';
import 'package:scoring_app/screens/sport_selection/sport_selection_screen.dart';

class AppRoutes {
  static const sportSelection = '/sport-selection';
  static const cricketDashboard = '/dashboard/cricket';
  static const badmintonDashboard = '/dashboard/badminton';
  static const tennisDashboard = '/dashboard/tennis';
  static const footballDashboard = '/dashboard/football';
  static const sportAction = '/sport-action';
  static const teams = '/teams';
  static const newMatch = '/new-match';
  static const history = '/history';
  static const scoring = '/scoring/:matchId/:inningsId';
}

class AppRouteNames {
  static const sportSelection = 'sportSelection';
  static const cricketDashboard = 'cricketDashboard';
  static const badmintonDashboard = 'badmintonDashboard';
  static const tennisDashboard = 'tennisDashboard';
  static const footballDashboard = 'footballDashboard';
  static const sportAction = 'sportAction';
  static const teams = 'teams';
  static const newMatch = 'newMatch';
  static const history = 'history';
  static const scoring = 'scoring';
}

String _resolveSportId(GoRouterState state, {String fallback = 'cricket'}) {
  return state.uri.queryParameters['sportId'] ?? fallback;
}

String? _resolveSelectedFormat(GoRouterState state) {
  return state.uri.queryParameters['selectedFormat'];
}

GoRouter createAppRouter({required String initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutes.sportSelection,
        name: AppRouteNames.sportSelection,
        builder: (context, state) => const SportSelectionScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        redirect: (context, state) => AppRoutes.cricketDashboard,
      ),
      GoRoute(
        path: AppRoutes.cricketDashboard,
        name: AppRouteNames.cricketDashboard,
        builder: (context, state) => CricketDashboardScreen(
          sportId: _resolveSportId(state, fallback: 'cricket'),
        ),
      ),
      GoRoute(
        path: AppRoutes.badmintonDashboard,
        name: AppRouteNames.badmintonDashboard,
        builder: (context, state) => BadmintonDashboardScreen(
          sportId: _resolveSportId(state, fallback: 'badminton'),
        ),
      ),
      GoRoute(
        path: AppRoutes.tennisDashboard,
        name: AppRouteNames.tennisDashboard,
        builder: (context, state) => TennisDashboardScreen(
          sportId: _resolveSportId(state, fallback: 'tennis'),
        ),
      ),
      GoRoute(
        path: AppRoutes.footballDashboard,
        name: AppRouteNames.footballDashboard,
        builder: (context, state) => FootballDashboardScreen(
          sportId: _resolveSportId(state, fallback: 'football'),
        ),
      ),
      GoRoute(
        path: AppRoutes.sportAction,
        name: AppRouteNames.sportAction,
        builder: (context, state) {
          final action = state.extra as DashboardActionData?;
          if (action == null) {
            return const CricketDashboardScreen();
          }
          return SportActionScreen(action: action);
        },
      ),
      GoRoute(
        path: AppRoutes.teams,
        name: AppRouteNames.teams,
        builder: (context, state) => TeamsScreen(
          sportId: _resolveSportId(state),
          selectedFormat: _resolveSelectedFormat(state),
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              return TeamDetailScreen(
                teamId: state.pathParameters['id']!,
                sportId: _resolveSportId(state),
                selectedFormat: _resolveSelectedFormat(state),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.newMatch,
        name: AppRouteNames.newMatch,
        builder: (context, state) =>
            CreateMatchScreen(sportId: _resolveSportId(state)),
      ),
      GoRoute(
        path: AppRoutes.history,
        name: AppRouteNames.history,
        builder: (context, state) =>
            MatchHistoryScreen(sportId: _resolveSportId(state)),
      ),
      GoRoute(
        path: AppRoutes.scoring,
        name: AppRouteNames.scoring,
        builder: (context, state) {
          return LiveScoringScreen(
            matchId: state.pathParameters['matchId']!,
            inningsId: state.pathParameters['inningsId']!,
            sportId: _resolveSportId(state),
          );
        },
      ),
    ],
  );
}
