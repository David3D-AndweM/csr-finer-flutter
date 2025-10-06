import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/dashboard/csr_manager_dashboard.dart';
import '../pages/dashboard/recipient_dashboard.dart';
import '../pages/dashboard/finance_dashboard.dart';
import '../pages/dashboard/me_dashboard.dart';
import '../pages/dashboard/editor_dashboard.dart';
import '../pages/projects/projects_page.dart';
import '../pages/projects/project_details_page.dart';
import '../pages/projects/create_project_page.dart';
import '../pages/budgets/budgets_page.dart';
import '../pages/budgets/budget_details_page.dart';
import '../pages/milestones/milestones_page.dart';
import '../pages/milestones/milestone_details_page.dart';
import '../pages/surveys/surveys_page.dart';
import '../pages/surveys/survey_details_page.dart';
import '../pages/messages/messages_page.dart';
import '../pages/messages/chat_page.dart';
import '../pages/reports/reports_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/users/users_page.dart';
import '../pages/content/content_page.dart';
import '../pages/error/error_page.dart';
import '../providers/auth_provider.dart';
import '../../domain/entities/user.dart';

// Route names as constants
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Dashboard routes
  static const String csrManagerDashboard = '/csr-dashboard';
  static const String recipientDashboard = '/recipient-dashboard';
  static const String financeDashboard = '/finance-dashboard';
  static const String meDashboard = '/me-dashboard';
  static const String editorDashboard = '/editor-dashboard';
  
  // Feature routes
  static const String projects = '/projects';
  static const String projectDetails = '/projects/:id';
  static const String createProject = '/projects/create';
  static const String budgets = '/budgets';
  static const String budgetDetails = '/budgets/:id';
  static const String milestones = '/milestones';
  static const String milestoneDetails = '/milestones/:id';
  static const String surveys = '/surveys';
  static const String surveyDetails = '/surveys/:id';
  static const String messages = '/messages';
  static const String chat = '/messages/chat/:userId';
  static const String reports = '/reports';
  static const String users = '/users';
  static const String content = '/content';
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  // Error routes
  static const String error = '/error';
}

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.maybeWhen(
        authenticated: (user) => true,
        orElse: () => false,
      );
      
      final isLoading = authState.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );
      
      // Show splash while loading
      if (isLoading) {
        return AppRoutes.splash;
      }
      
      // Public routes that don't require authentication
      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.onboarding,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
        AppRoutes.error,
      ];
      
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);
      
      // Redirect to login if not authenticated and trying to access protected route
      if (!isLoggedIn && !isPublicRoute) {
        return AppRoutes.login;
      }
      
      // Redirect to appropriate dashboard if logged in and on public route
      if (isLoggedIn && isPublicRoute && state.matchedLocation != AppRoutes.splash) {
        return _getDashboardRoute(authState.maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        ));
      }
      
      return null; // No redirect needed
    },
    routes: [
      // Splash Route
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Onboarding Route
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      
      // Dashboard Routes
      GoRoute(
        path: AppRoutes.csrManagerDashboard,
        name: 'csr-manager-dashboard',
        builder: (context, state) => const CSRManagerDashboard(),
      ),
      GoRoute(
        path: AppRoutes.recipientDashboard,
        name: 'recipient-dashboard',
        builder: (context, state) => const RecipientDashboard(),
      ),
      GoRoute(
        path: AppRoutes.financeDashboard,
        name: 'finance-dashboard',
        builder: (context, state) => const FinanceDashboard(),
      ),
      GoRoute(
        path: AppRoutes.meDashboard,
        name: 'me-dashboard',
        builder: (context, state) => const MEDashboard(),
      ),
      GoRoute(
        path: AppRoutes.editorDashboard,
        name: 'editor-dashboard',
        builder: (context, state) => const EditorDashboard(),
      ),
      
      // Projects Routes
      GoRoute(
        path: AppRoutes.projects,
        name: 'projects',
        builder: (context, state) => const ProjectsPage(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create-project',
            builder: (context, state) => const CreateProjectPage(),
          ),
          GoRoute(
            path: ':id',
            name: 'project-details',
            builder: (context, state) {
              final projectId = state.pathParameters['id']!;
              return ProjectDetailsPage(projectId: projectId);
            },
          ),
        ],
      ),
      
      // Budgets Routes
      GoRoute(
        path: AppRoutes.budgets,
        name: 'budgets',
        builder: (context, state) => const BudgetsPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'budget-details',
            builder: (context, state) {
              final budgetId = state.pathParameters['id']!;
              return BudgetDetailsPage(budgetId: budgetId);
            },
          ),
        ],
      ),
      
      // Milestones Routes
      GoRoute(
        path: AppRoutes.milestones,
        name: 'milestones',
        builder: (context, state) => const MilestonesPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'milestone-details',
            builder: (context, state) {
              final milestoneId = state.pathParameters['id']!;
              return MilestoneDetailsPage(milestoneId: milestoneId);
            },
          ),
        ],
      ),
      
      // Surveys Routes
      GoRoute(
        path: AppRoutes.surveys,
        name: 'surveys',
        builder: (context, state) => const SurveysPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'survey-details',
            builder: (context, state) {
              final surveyId = state.pathParameters['id']!;
              return SurveyDetailsPage(surveyId: surveyId);
            },
          ),
        ],
      ),
      
      // Messages Routes
      GoRoute(
        path: AppRoutes.messages,
        name: 'messages',
        builder: (context, state) => const MessagesPage(),
        routes: [
          GoRoute(
            path: 'chat/:userId',
            name: 'chat',
            builder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return ChatPage(userId: userId);
            },
          ),
        ],
      ),
      
      // Other Feature Routes
      GoRoute(
        path: AppRoutes.reports,
        name: 'reports',
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: AppRoutes.users,
        name: 'users',
        builder: (context, state) => const UsersPage(),
      ),
      GoRoute(
        path: AppRoutes.content,
        name: 'content',
        builder: (context, state) => const ContentPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      
      // Error Route
      GoRoute(
        path: AppRoutes.error,
        name: 'error',
        builder: (context, state) {
          final error = state.extra as String?;
          return ErrorPage(error: error);
        },
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(
      error: 'Page not found: ${state.matchedLocation}',
    ),
  );
});

// Helper function to get dashboard route based on user role
String _getDashboardRoute(User? user) {
  if (user == null) return AppRoutes.login;
  
  switch (user.role) {
    case UserRole.csrManager:
      return AppRoutes.csrManagerDashboard;
    case UserRole.recipient:
      return AppRoutes.recipientDashboard;
    case UserRole.financeOfficer:
      return AppRoutes.financeDashboard;
    case UserRole.monitoringEvaluationOfficer:
      return AppRoutes.meDashboard;
    case UserRole.editor:
      return AppRoutes.editorDashboard;
    default:
      return AppRoutes.login;
  }
}

// Navigation helper class
class AppNavigation {
  static void goToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }
  
  static void goToRegister(BuildContext context) {
    context.go(AppRoutes.register);
  }
  
  static void goToDashboard(BuildContext context, UserRole role) {
    final route = _getDashboardRouteByRole(role);
    context.go(route);
  }
  
  static void goToProjects(BuildContext context) {
    context.go(AppRoutes.projects);
  }
  
  static void goToProjectDetails(BuildContext context, String projectId) {
    context.go('/projects/$projectId');
  }
  
  static void goToCreateProject(BuildContext context) {
    context.go('/projects/create');
  }
  
  static void goToBudgets(BuildContext context) {
    context.go(AppRoutes.budgets);
  }
  
  static void goToBudgetDetails(BuildContext context, String budgetId) {
    context.go('/budgets/$budgetId');
  }
  
  static void goToMilestones(BuildContext context) {
    context.go(AppRoutes.milestones);
  }
  
  static void goToMilestoneDetails(BuildContext context, String milestoneId) {
    context.go('/milestones/$milestoneId');
  }
  
  static void goToSurveys(BuildContext context) {
    context.go(AppRoutes.surveys);
  }
  
  static void goToSurveyDetails(BuildContext context, String surveyId) {
    context.go('/surveys/$surveyId');
  }
  
  static void goToMessages(BuildContext context) {
    context.go(AppRoutes.messages);
  }
  
  static void goToChat(BuildContext context, String userId) {
    context.go('/messages/chat/$userId');
  }
  
  static void goToReports(BuildContext context) {
    context.go(AppRoutes.reports);
  }
  
  static void goToUsers(BuildContext context) {
    context.go(AppRoutes.users);
  }
  
  static void goToContent(BuildContext context) {
    context.go(AppRoutes.content);
  }
  
  static void goToProfile(BuildContext context) {
    context.go(AppRoutes.profile);
  }
  
  static void goToSettings(BuildContext context) {
    context.go(AppRoutes.settings);
  }
  
  static void goBack(BuildContext context) {
    context.pop();
  }
  
  static void goToError(BuildContext context, String error) {
    context.go(AppRoutes.error, extra: error);
  }
}

String _getDashboardRouteByRole(UserRole role) {
  switch (role) {
    case UserRole.csrManager:
      return AppRoutes.csrManagerDashboard;
    case UserRole.recipient:
      return AppRoutes.recipientDashboard;
    case UserRole.financeOfficer:
      return AppRoutes.financeDashboard;
    case UserRole.monitoringEvaluationOfficer:
      return AppRoutes.meDashboard;
    case UserRole.editor:
      return AppRoutes.editorDashboard;
  }
}
