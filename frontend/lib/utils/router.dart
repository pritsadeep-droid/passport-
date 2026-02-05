import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../screens/auth/login_screen.dart';
import '../screens/employee/employee_home_screen.dart';
import '../screens/employee/self_assessment_screen.dart';
import '../screens/supervisor/supervisor_home_screen.dart';
import '../screens/supervisor/team_list_screen.dart';
import '../screens/supervisor/employee_detail_screen.dart';
import '../screens/supervisor/create_kpi_screen.dart';
import '../screens/supervisor/milestone_detail_screen.dart';
import '../screens/supervisor/milestone_approval_screen.dart';
import '../screens/supervisor/pending_approvals_screen.dart';
import '../screens/common/notifications_screen.dart';
import '../screens/hr/hr_home_screen.dart';
import '../screens/hr/hr_dashboard_screen.dart';
import '../screens/hr/all_employees_screen.dart';
import '../screens/hr/employee_review_screen.dart';
import '../screens/hr/reports_screen.dart';
import '../screens/hr/create_user_screen.dart';
import '../screens/hr/milestone_settings_screen.dart';
import '../screens/hr/kpi_template_screen.dart';
import '../screens/hr/onboarding_template_screen.dart';
import '../screens/onboarding/onboarding_timeline_screen.dart';
import '../screens/onboarding/mission_detail_screen.dart';
import '../screens/manager/onboarding_review_screen.dart';
import '../widgets/loading.dart';

/// Route names
class Routes {
  // Auth routes
  static const String login = '/login';

  // Employee routes
  static const String employeeHome = '/employee';
  static const String employeeDashboard = '/employee/dashboard';
  static const String selfAssessment = '/employee/assessment/:recordId/:day';
  static const String onboarding = '/employee/onboarding';
  static const String missionDetail = '/employee/onboarding/mission/:code';

  // Supervisor routes
  static const String supervisorHome = '/supervisor';
  static const String teamList = '/supervisor/team';
  static const String employeeDetail = '/supervisor/employee/:id';
  static const String createKpi = '/supervisor/employee/:id/kpi/create';
  static const String pendingApprovals = '/supervisor/pending-approvals';
  static const String milestoneDetail =
      '/supervisor/milestone/:recordId/:day';
  static const String milestoneApproval =
      '/supervisor/milestone-approval/:recordId/:day';
  static const String onboardingReview = '/supervisor/onboarding-review/:id';

  // HR routes
  static const String hrHome = '/hr';
  static const String hrDashboard = '/hr/dashboard';
  static const String allEmployees = '/hr/employees';
  static const String employeeReview = '/hr/employee/:id/review';
  static const String createUser = '/hr/create-user';
  static const String milestoneSettings = '/hr/milestone-settings';
  static const String kpiTemplates = '/hr/kpi-templates';
  static const String onboardingTemplates = '/hr/onboarding-templates';
  static const String reports = '/hr/reports';

  // Common routes
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: Routes.login,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(ref, authProvider),
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == Routes.login;
      final isAuthenticated = authState.isAuthenticated;
      final isLoading =
          authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading;

      // Show loading while checking auth status
      if (isLoading && !isLoggingIn) {
        return null; // Let the loading screen handle this
      }

      // Redirect to login if not authenticated
      if (!isAuthenticated && !isLoggingIn) {
        return Routes.login;
      }

      // Redirect to appropriate home based on role
      if (isAuthenticated && isLoggingIn) {
        return _getHomeRouteForRole(authState.user?.role);
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Employee routes
      GoRoute(
        path: Routes.employeeHome,
        name: 'employeeHome',
        builder: (context, state) => const EmployeeHomeScreen(),
        routes: [
          GoRoute(
            path: 'dashboard',
            name: 'employeeDashboard',
            builder: (context, state) => const EmployeeHomeScreen(),
          ),
          GoRoute(
            path: 'assessment/:recordId/:day',
            name: 'selfAssessment',
            builder: (context, state) {
              final recordId = state.pathParameters['recordId']!;
              final day = int.parse(state.pathParameters['day']!);
              return SelfAssessmentScreen(
                recordId: recordId,
                day: day,
              );
            },
          ),
          GoRoute(
            path: 'milestone/:recordId/:day',
            name: 'employeeMilestoneDetail',
            builder: (context, state) {
              final recordId = state.pathParameters['recordId']!;
              final day = int.parse(state.pathParameters['day']!);
              return MilestoneDetailScreen(
                probationRecordId: recordId,
                day: day,
              );
            },
          ),
          GoRoute(
            path: 'onboarding',
            name: 'onboarding',
            builder: (context, state) => const OnboardingTimelineScreen(),
            routes: [
              GoRoute(
                path: 'mission/:code',
                name: 'missionDetail',
                builder: (context, state) => MissionDetailScreen(
                  missionCode: state.pathParameters['code']!,
                ),
              ),
            ],
          ),
        ],
      ),

      // Supervisor routes
      GoRoute(
        path: Routes.supervisorHome,
        name: 'supervisorHome',
        builder: (context, state) => const SupervisorHomeScreen(),
        routes: [
          GoRoute(
            path: 'team',
            name: 'teamList',
            builder: (context, state) => const TeamListScreen(),
          ),
          GoRoute(
            path: 'pending-approvals',
            name: 'pendingApprovals',
            builder: (context, state) => const PendingApprovalsScreen(),
          ),
          GoRoute(
            path: 'milestone/:recordId/:day',
            name: 'milestoneDetail',
            builder: (context, state) {
              final recordId = state.pathParameters['recordId']!;
              final day = int.parse(state.pathParameters['day']!);
              return MilestoneDetailScreen(
                probationRecordId: recordId,
                day: day,
              );
            },
          ),
          GoRoute(
            path: 'milestone-approval/:recordId/:day',
            name: 'milestoneApproval',
            builder: (context, state) {
              final recordId = state.pathParameters['recordId']!;
              final day = int.parse(state.pathParameters['day']!);
              return MilestoneApprovalScreen(
                probationRecordId: recordId,
                day: day,
              );
            },
          ),
          GoRoute(
            path: 'employee/:id',
            name: 'employeeDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EmployeeDetailScreen(employeeId: id);
            },
            routes: [
              GoRoute(
                path: 'kpi/create',
                name: 'createKpi',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return CreateKpiScreen(probationRecordId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'onboarding-review/:id',
            name: 'onboardingReview',
            builder: (context, state) => OnboardingReviewScreen(
              onboardingId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),

      // HR routes
      GoRoute(
        path: Routes.hrHome,
        name: 'hrHome',
        builder: (context, state) => const HRHomeScreen(),
        routes: [
          GoRoute(
            path: 'dashboard',
            name: 'hrDashboard',
            builder: (context, state) => const HRDashboardScreen(),
          ),
          GoRoute(
            path: 'employees',
            name: 'allEmployees',
            builder: (context, state) {
              final status = state.uri.queryParameters['status'];
              final department = state.uri.queryParameters['department'];
              return AllEmployeesScreen(
                initialStatus: status,
                initialDepartment: department,
              );
            },
          ),
          GoRoute(
            path: 'employee/:id/review',
            name: 'employeeReview',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EmployeeReviewScreen(employeeId: id);
            },
          ),

          GoRoute(
            path: 'create-user',
            name: 'createUser',
            builder: (context, state) => const CreateUserScreen(),
          ),
          GoRoute(
            path: 'milestone-settings',
            name: 'milestoneSettings',
            builder: (context, state) => const MilestoneSettingsScreen(),
          ),
          GoRoute(
            path: 'kpi-templates',
            name: 'kpiTemplates',
            builder: (context, state) => const KpiTemplateScreen(),
          ),
          GoRoute(
            path: 'onboarding-templates',
            name: 'onboardingTemplates',
            builder: (context, state) => const OnboardingTemplateScreen(),
          ),
          GoRoute(
            path: 'reports',
            name: 'reports',
            builder: (context, state) => const ReportsScreen(),
          ),
        ],
      ),

      // Common routes
      GoRoute(
        path: Routes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        name: 'profile',
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
      GoRoute(
        path: Routes.settings,
        name: 'settings',
        builder: (context, state) => const _PlaceholderScreen(title: 'Settings'),
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
});

/// Get home route based on user role
String _getHomeRouteForRole(UserRole? role) {
  switch (role) {
    case UserRole.employee:
      return Routes.employeeHome;
    case UserRole.supervisor:
      return Routes.supervisorHome;
    case UserRole.hrAdmin:
      return Routes.hrHome;
    default:
      return Routes.login;
  }
}

/// Refresh stream for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this._ref, this._provider) {
    _ref.listen(_provider, (_, __) => notifyListeners());
  }

  final Ref _ref;
  final StateNotifierProvider<AuthNotifier, AuthState> _provider;
}

/// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen for route errors
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Routes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
