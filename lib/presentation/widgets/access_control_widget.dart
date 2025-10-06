import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/access_control.dart';
import '../../core/security/permissions.dart';
import '../../domain/entities/user.dart';

/// Widget that conditionally shows content based on user permissions
class PermissionWidget extends ConsumerWidget {
  final Permission permission;
  final Widget child;
  final Widget? fallback;
  final VoidCallback? onAccessDenied;
  
  const PermissionWidget({
    Key? key,
    required this.permission,
    required this.child,
    this.fallback,
    this.onAccessDenied,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessControl = ref.watch(accessControlProvider);
    
    if (accessControl.hasPermission(permission)) {
      return child;
    } else {
      onAccessDenied?.call();
      return fallback ?? const SizedBox.shrink();
    }
  }
}

/// Widget that shows content based on multiple permissions (any)
class AnyPermissionWidget extends ConsumerWidget {
  final List<Permission> permissions;
  final Widget child;
  final Widget? fallback;
  final VoidCallback? onAccessDenied;
  
  const AnyPermissionWidget({
    Key? key,
    required this.permissions,
    required this.child,
    this.fallback,
    this.onAccessDenied,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessControl = ref.watch(accessControlProvider);
    
    if (accessControl.hasAnyPermission(permissions)) {
      return child;
    } else {
      onAccessDenied?.call();
      return fallback ?? const SizedBox.shrink();
    }
  }
}

/// Widget that shows content based on multiple permissions (all)
class AllPermissionsWidget extends ConsumerWidget {
  final List<Permission> permissions;
  final Widget child;
  final Widget? fallback;
  final VoidCallback? onAccessDenied;
  
  const AllPermissionsWidget({
    Key? key,
    required this.permissions,
    required this.child,
    this.fallback,
    this.onAccessDenied,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessControl = ref.watch(accessControlProvider);
    
    if (accessControl.hasAllPermissions(permissions)) {
      return child;
    } else {
      onAccessDenied?.call();
      return fallback ?? const SizedBox.shrink();
    }
  }
}

/// Widget that shows different content based on user role
class RoleBasedWidget extends ConsumerWidget {
  final Map<UserRole, Widget> roleWidgets;
  final Widget? defaultWidget;
  
  const RoleBasedWidget({
    Key? key,
    required this.roleWidgets,
    this.defaultWidget,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessControl = ref.watch(accessControlProvider);
    final currentUser = accessControl.currentUser;
    
    if (currentUser == null) {
      return defaultWidget ?? const SizedBox.shrink();
    }
    
    return roleWidgets[currentUser.role] ?? 
           defaultWidget ?? 
           const SizedBox.shrink();
  }
}

/// Widget that shows access denied message
class AccessDeniedWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  
  const AccessDeniedWidget({
    Key? key,
    this.message,
    this.onRetry,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Access Denied',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'You do not have permission to access this resource.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            if (onRetry != null) ..[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Mixin for pages that require specific permissions
mixin PermissionRequiredMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  List<Permission> get requiredPermissions;
  bool get requireAllPermissions => false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissions();
    });
  }
  
  void _checkPermissions() {
    final accessControl = ref.read(accessControlProvider);
    
    bool hasAccess;
    if (requireAllPermissions) {
      hasAccess = accessControl.hasAllPermissions(requiredPermissions);
    } else {
      hasAccess = accessControl.hasAnyPermission(requiredPermissions);
    }
    
    if (!hasAccess) {
      _handleAccessDenied();
    }
  }
  
  void _handleAccessDenied() {
    // Override this method to handle access denied
    // Default implementation shows a snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You do not have permission to access this page.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}

/// Helper class for common permission checks
class PermissionHelper {
  static Widget buildPermissionButton({
    required WidgetRef ref,
    required Permission permission,
    required VoidCallback onPressed,
    required Widget child,
    Widget? disabledChild,
    String? tooltip,
  }) {
    final accessControl = ref.watch(accessControlProvider);
    final hasPermission = accessControl.hasPermission(permission);
    
    if (!hasPermission) {
      return Tooltip(
        message: tooltip ?? 'You do not have permission to perform this action',
        child: disabledChild ?? Opacity(
          opacity: 0.5,
          child: IgnorePointer(child: child),
        ),
      );
    }
    
    return GestureDetector(
      onTap: onPressed,
      child: child,
    );
  }
  
  static List<Widget> filterMenuItems({
    required WidgetRef ref,
    required List<MenuItemData> items,
  }) {
    final accessControl = ref.watch(accessControlProvider);
    
    return items
        .where((item) => item.permission == null || 
                        accessControl.hasPermission(item.permission!))
        .map((item) => item.widget)
        .toList();
  }
}

class MenuItemData {
  final Widget widget;
  final Permission? permission;
  
  const MenuItemData({
    required this.widget,
    this.permission,
  });
}
