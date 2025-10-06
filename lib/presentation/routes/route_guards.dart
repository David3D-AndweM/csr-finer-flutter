import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../domain/entities/user.dart';
import 'app_router.dart';

/// Route guard that checks if user is authenticated
class AuthGuard {
  static bool isAuthenticated(WidgetRef ref) {
    return ref.read(authStateProvider).maybeWhen(
      authenticated: (user) => true,
      orElse: () => false,
    );
  }
  
  static User? getCurrentUser(WidgetRef ref) {
    return ref.read(authStateProvider).maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
  }
}

/// Route guard that checks user roles
class RoleGuard {
  static bool hasRole(WidgetRef ref, UserRole requiredRole) {
    final user = AuthGuard.getCurrentUser(ref);
    return user?.role == requiredRole;
  }
  
  static bool hasAnyRole(WidgetRef ref, List<UserRole> allowedRoles) {
    final user = AuthGuard.getCurrentUser(ref);
    if (user == null) return false;
    return allowedRoles.contains(user.role);
  }
  
  static bool canAccessCSRManagerFeatures(WidgetRef ref) {
    return hasRole(ref, UserRole.csrManager);
  }
  
  static bool canAccessFinanceFeatures(WidgetRef ref) {
    return hasAnyRole(ref, [UserRole.csrManager, UserRole.financeOfficer]);
  }
  
  static bool canAccessMEFeatures(WidgetRef ref) {
    return hasAnyRole(ref, [
      UserRole.csrManager,
      UserRole.monitoringEvaluationOfficer,
    ]);
  }
  
  static bool canAccessRecipientFeatures(WidgetRef ref) {
    return hasAnyRole(ref, [
      UserRole.csrManager,
      UserRole.recipient,
      UserRole.monitoringEvaluationOfficer,
    ]);
  }
  
  static bool canAccessEditorFeatures(WidgetRef ref) {
    return hasAnyRole(ref, [UserRole.csrManager, UserRole.editor]);
  }
  
  static bool canAccessUserManagement(WidgetRef ref) {
    return hasRole(ref, UserRole.csrManager);
  }
  
  static bool canCreateProjects(WidgetRef ref) {
    return hasAnyRole(ref, [UserRole.csrManager, UserRole.recipient]);
  }
  
  static bool canManageBudgets(WidgetRef ref) {
    return hasAnyRole(ref, [UserRole.csrManager, UserRole.financeOfficer]);
  }
  
  static bool canViewAllProjects(WidgetRef ref) {
    return hasAnyRole(ref, [
      UserRole.csrManager,
      UserRole.financeOfficer,
      UserRole.monitoringEvaluationOfficer,
    ]);
  }
  
  static bool canEditProject(WidgetRef ref, String projectOwnerId) {
    final user = AuthGuard.getCurrentUser(ref);
    if (user == null) return false;
    
    // CSR Manager can edit any project
    if (user.role == UserRole.csrManager) return true;
    
    // Recipients can only edit their own projects
    if (user.role == UserRole.recipient) {
      return user.id == projectOwnerId;
    }
    
    return false;
  }
  
  static bool canApproveMilestones(WidgetRef ref) {
    return hasAnyRole(ref, [
      UserRole.csrManager,
      UserRole.monitoringEvaluationOfficer,
    ]);
  }
  
  static bool canCreateSurveys(WidgetRef ref) {
    return hasAnyRole(ref, [
      UserRole.csrManager,
      UserRole.monitoringEvaluationOfficer,
    ]);
  }
  
  static bool canViewReports(WidgetRef ref) {
    return hasAnyRole(ref, [
      UserRole.csrManager,
      UserRole.financeOfficer,
      UserRole.monitoringEvaluationOfficer,
    ]);
  }
  
  static bool canExportData(WidgetRef ref) {
    return hasAnyRole(ref, [
      UserRole.csrManager,
      UserRole.financeOfficer,
      UserRole.monitoringEvaluationOfficer,
    ]);
  }
}

/// Widget that conditionally shows content based on authentication
class AuthGuardWidget extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;
  final VoidCallback? onUnauthorized;
  
  const AuthGuardWidget({
    Key? key,
    required this.child,
    this.fallback,
    this.onUnauthorized,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = AuthGuard.isAuthenticated(ref);
    
    if (!isAuthenticated) {
      onUnauthorized?.call();
      return fallback ?? const SizedBox.shrink();
    }
    
    return child;
  }
}

/// Widget that conditionally shows content based on user role
class RoleGuardWidget extends ConsumerWidget {
  final Widget child;
  final List<UserRole> allowedRoles;
  final Widget? fallback;
  final VoidCallback? onUnauthorized;
  
  const RoleGuardWidget({
    Key? key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
    this.onUnauthorized,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPermission = RoleGuard.hasAnyRole(ref, allowedRoles);
    
    if (!hasPermission) {
      onUnauthorized?.call();
      return fallback ?? const SizedBox.shrink();
    }
    
    return child;
  }
}

/// Widget that shows different content based on user role
class RoleBasedWidget extends ConsumerWidget {
  final Widget? csrManagerWidget;
  final Widget? recipientWidget;
  final Widget? financeOfficerWidget;
  final Widget? meOfficerWidget;
  final Widget? editorWidget;
  final Widget? defaultWidget;
  
  const RoleBasedWidget({
    Key? key,
    this.csrManagerWidget,
    this.recipientWidget,
    this.financeOfficerWidget,
    this.meOfficerWidget,
    this.editorWidget,
    this.defaultWidget,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = AuthGuard.getCurrentUser(ref);
    
    if (user == null) {
      return defaultWidget ?? const SizedBox.shrink();
    }
    
    switch (user.role) {
      case UserRole.csrManager:
        return csrManagerWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.recipient:
        return recipientWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.financeOfficer:
        return financeOfficerWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.monitoringEvaluationOfficer:
        return meOfficerWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.editor:
        return editorWidget ?? defaultWidget ?? const SizedBox.shrink();
      default:
        return defaultWidget ?? const SizedBox.shrink();
    }
  }
}

/// Mixin for pages that require authentication
mixin AuthRequiredMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AuthGuard.isAuthenticated(ref)) {
        AppNavigation.goToLogin(context);
      }
    });
  }
}

/// Mixin for pages that require specific roles
mixin RoleRequiredMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  List<UserRole> get requiredRoles;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AuthGuard.isAuthenticated(ref)) {
        AppNavigation.goToLogin(context);
        return;
      }
      
      if (!RoleGuard.hasAnyRole(ref, requiredRoles)) {
        AppNavigation.goToError(context, 'Access denied. Insufficient permissions.');
      }
    });
  }
}
