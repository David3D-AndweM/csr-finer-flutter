import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../presentation/providers/auth_provider.dart';
import 'permissions.dart';

/// Access control service for checking user permissions
class AccessControlService {
  final User? _currentUser;
  
  AccessControlService(this._currentUser);
  
  /// Check if current user has a specific permission
  bool hasPermission(Permission permission) {
    if (_currentUser == null) return false;
    return RolePermissions.hasPermission(_currentUser!.role, permission);
  }
  
  /// Check if current user has any of the specified permissions
  bool hasAnyPermission(List<Permission> permissions) {
    if (_currentUser == null) return false;
    return RolePermissions.hasAnyPermission(_currentUser!.role, permissions);
  }
  
  /// Check if current user has all of the specified permissions
  bool hasAllPermissions(List<Permission> permissions) {
    if (_currentUser == null) return false;
    return RolePermissions.hasAllPermissions(_currentUser!.role, permissions);
  }
  
  /// Check if current user can access a specific resource
  bool canAccessResource(String resourceId, Permission permission) {
    if (!hasPermission(permission)) return false;
    
    // Additional resource-specific checks can be added here
    // For example, checking if user owns the resource
    return true;
  }
  
  /// Check if current user can edit a specific project
  bool canEditProject(String projectId, String projectOwnerId) {
    if (_currentUser == null) return false;
    
    // CSR Manager can edit any project
    if (hasPermission(Permission.editAllProjects)) return true;
    
    // Recipients can only edit their own projects
    if (hasPermission(Permission.editOwnProjects)) {
      return _currentUser!.id == projectOwnerId;
    }
    
    return false;
  }
  
  /// Check if current user can view a specific project
  bool canViewProject(String projectId, String projectOwnerId) {
    if (_currentUser == null) return false;
    
    // Users with viewAllProjects can see any project
    if (hasPermission(Permission.viewAllProjects)) return true;
    
    // Recipients can only view their own projects
    if (hasPermission(Permission.viewOwnProjects)) {
      return _currentUser!.id == projectOwnerId;
    }
    
    return false;
  }
  
  /// Check if current user can approve milestones
  bool canApproveMilestones() {
    return hasPermission(Permission.approveMilestones);
  }
  
  /// Check if current user can manage budgets
  bool canManageBudgets() {
    return hasAnyPermission([
      Permission.createBudgets,
      Permission.editBudgets,
      Permission.manageBudgetAllocations,
    ]);
  }
  
  /// Check if current user can create surveys
  bool canCreateSurveys() {
    return hasPermission(Permission.createSurveys);
  }
  
  /// Check if current user can view reports
  bool canViewReports() {
    return hasPermission(Permission.viewReports);
  }
  
  /// Check if current user can export data
  bool canExportData() {
    return hasPermission(Permission.exportReports);
  }
  
  /// Check if current user can manage content
  bool canManageContent() {
    return hasAnyPermission([
      Permission.createContent,
      Permission.editContent,
      Permission.publishContent,
    ]);
  }
  
  /// Check if current user can manage users
  bool canManageUsers() {
    return hasAnyPermission([
      Permission.createUsers,
      Permission.editUsers,
      Permission.deleteUsers,
      Permission.manageUserRoles,
    ]);
  }
  
  /// Get user's role display name
  String get roleDisplayName {
    return _currentUser?.roleDisplayName ?? 'Unknown';
  }
  
  /// Get user's permissions
  Set<Permission> get permissions {
    if (_currentUser == null) return <Permission>{};
    return RolePermissions.getPermissionsForRole(_currentUser!.role);
  }
  
  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;
  
  /// Get current user
  User? get currentUser => _currentUser;
}

/// Provider for access control service
final accessControlProvider = Provider<AccessControlService>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return AccessControlService(currentUser);
});
