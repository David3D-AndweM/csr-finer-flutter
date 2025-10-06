import '../../../domain/entities/user.dart';

/// Defines all permissions in the CSR CRM system
enum Permission {
  // User Management
  viewUsers,
  createUsers,
  editUsers,
  deleteUsers,
  manageUserRoles,
  
  // Project Management
  viewAllProjects,
  viewOwnProjects,
  createProjects,
  editOwnProjects,
  editAllProjects,
  deleteProjects,
  approveProjects,
  
  // Milestone Management
  viewMilestones,
  createMilestones,
  editMilestones,
  deleteMilestones,
  approveMilestones,
  
  // Budget Management
  viewBudgets,
  createBudgets,
  editBudgets,
  deleteBudgets,
  approveBudgets,
  manageBudgetAllocations,
  
  // Survey Management
  viewSurveys,
  createSurveys,
  editSurveys,
  deleteSurveys,
  respondToSurveys,
  viewSurveyResponses,
  
  // Reporting
  viewReports,
  createReports,
  exportReports,
  viewAnalytics,
  
  // Content Management
  viewContent,
  createContent,
  editContent,
  deleteContent,
  publishContent,
  
  // Messaging
  sendMessages,
  viewMessages,
  deleteMessages,
  
  // System Administration
  viewSystemSettings,
  editSystemSettings,
  viewAuditLogs,
  manageNotifications,
  
  // File Management
  uploadFiles,
  downloadFiles,
  deleteFiles,
  
  // MOU Management
  viewMOUs,
  createMOUs,
  editMOUs,
  deleteMOUs,
  approveMOUs,
  signMOUs,
}

/// Maps user roles to their permissions
class RolePermissions {
  static const Map<UserRole, Set<Permission>> _rolePermissions = {
    UserRole.csrManager: {
      // Full system access
      Permission.viewUsers,
      Permission.createUsers,
      Permission.editUsers,
      Permission.deleteUsers,
      Permission.manageUserRoles,
      
      Permission.viewAllProjects,
      Permission.createProjects,
      Permission.editAllProjects,
      Permission.deleteProjects,
      Permission.approveProjects,
      
      Permission.viewMilestones,
      Permission.createMilestones,
      Permission.editMilestones,
      Permission.deleteMilestones,
      Permission.approveMilestones,
      
      Permission.viewBudgets,
      Permission.createBudgets,
      Permission.editBudgets,
      Permission.deleteBudgets,
      Permission.approveBudgets,
      Permission.manageBudgetAllocations,
      
      Permission.viewSurveys,
      Permission.createSurveys,
      Permission.editSurveys,
      Permission.deleteSurveys,
      Permission.viewSurveyResponses,
      
      Permission.viewReports,
      Permission.createReports,
      Permission.exportReports,
      Permission.viewAnalytics,
      
      Permission.viewContent,
      Permission.createContent,
      Permission.editContent,
      Permission.deleteContent,
      Permission.publishContent,
      
      Permission.sendMessages,
      Permission.viewMessages,
      Permission.deleteMessages,
      
      Permission.viewSystemSettings,
      Permission.editSystemSettings,
      Permission.viewAuditLogs,
      Permission.manageNotifications,
      
      Permission.uploadFiles,
      Permission.downloadFiles,
      Permission.deleteFiles,
      
      Permission.viewMOUs,
      Permission.createMOUs,
      Permission.editMOUs,
      Permission.deleteMOUs,
      Permission.approveMOUs,
      Permission.signMOUs,
    },
    
    UserRole.recipient: {
      // Project and milestone management for own projects
      Permission.viewOwnProjects,
      Permission.createProjects,
      Permission.editOwnProjects,
      
      Permission.viewMilestones,
      Permission.createMilestones,
      Permission.editMilestones,
      
      Permission.respondToSurveys,
      
      Permission.sendMessages,
      Permission.viewMessages,
      
      Permission.uploadFiles,
      Permission.downloadFiles,
      
      Permission.viewMOUs,
    },
    
    UserRole.financeOfficer: {
      // Budget and financial management
      Permission.viewAllProjects,
      
      Permission.viewBudgets,
      Permission.createBudgets,
      Permission.editBudgets,
      Permission.manageBudgetAllocations,
      
      Permission.viewReports,
      Permission.createReports,
      Permission.exportReports,
      Permission.viewAnalytics,
      
      Permission.sendMessages,
      Permission.viewMessages,
      
      Permission.uploadFiles,
      Permission.downloadFiles,
      
      Permission.viewMOUs,
    },
    
    UserRole.monitoringEvaluationOfficer: {
      // Monitoring, evaluation, and survey management
      Permission.viewAllProjects,
      
      Permission.viewMilestones,
      Permission.editMilestones,
      Permission.approveMilestones,
      
      Permission.viewSurveys,
      Permission.createSurveys,
      Permission.editSurveys,
      Permission.viewSurveyResponses,
      
      Permission.viewReports,
      Permission.createReports,
      Permission.exportReports,
      Permission.viewAnalytics,
      
      Permission.sendMessages,
      Permission.viewMessages,
      
      Permission.uploadFiles,
      Permission.downloadFiles,
      
      Permission.viewMOUs,
    },
    
    UserRole.editor: {
      // Content management and basic project viewing
      Permission.viewAllProjects,
      
      Permission.viewContent,
      Permission.createContent,
      Permission.editContent,
      Permission.deleteContent,
      Permission.publishContent,
      
      Permission.sendMessages,
      Permission.viewMessages,
      
      Permission.uploadFiles,
      Permission.downloadFiles,
      
      Permission.viewReports,
      Permission.viewAnalytics,
    },
  };
  
  /// Get all permissions for a specific role
  static Set<Permission> getPermissionsForRole(UserRole role) {
    return _rolePermissions[role] ?? <Permission>{};
  }
  
  /// Check if a role has a specific permission
  static bool hasPermission(UserRole role, Permission permission) {
    return _rolePermissions[role]?.contains(permission) ?? false;
  }
  
  /// Check if a role has any of the specified permissions
  static bool hasAnyPermission(UserRole role, List<Permission> permissions) {
    final rolePermissions = _rolePermissions[role] ?? <Permission>{};
    return permissions.any((permission) => rolePermissions.contains(permission));
  }
  
  /// Check if a role has all of the specified permissions
  static bool hasAllPermissions(UserRole role, List<Permission> permissions) {
    final rolePermissions = _rolePermissions[role] ?? <Permission>{};
    return permissions.every((permission) => rolePermissions.contains(permission));
  }
  
  /// Get permissions that a role is missing from a list of required permissions
  static List<Permission> getMissingPermissions(UserRole role, List<Permission> requiredPermissions) {
    final rolePermissions = _rolePermissions[role] ?? <Permission>{};
    return requiredPermissions.where((permission) => !rolePermissions.contains(permission)).toList();
  }
}
