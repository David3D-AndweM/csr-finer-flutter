import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that conditionally shows content based on user permissions
class PermissionWidget extends ConsumerWidget {
  final String permission;
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
    // TODO: Implement access control logic when security layer is ready
    return child;
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
            if (onRetry != null) ...[
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
