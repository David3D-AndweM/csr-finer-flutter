import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/charts/budget_chart.dart';
import '../../widgets/charts/project_progress_chart.dart';
import '../../widgets/common/recent_activities.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class CSRManagerDashboard extends ConsumerWidget {
  const CSRManagerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSR Manager Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Manager!',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here\'s an overview of your CSR initiatives',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Key Statistics
            Text(
              'Key Statistics',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: const [
                StatCard(
                  title: 'Active Projects',
                  value: '24',
                  subtitle: '+3 this month',
                  icon: Icons.work,
                  color: AppColors.success,
                ),
                StatCard(
                  title: 'Total Budget',
                  value: '\$2.4M',
                  subtitle: 'FY 2024-25',
                  icon: Icons.account_balance_wallet,
                  color: AppColors.primary,
                ),
                StatCard(
                  title: 'Partners',
                  value: '18',
                  subtitle: '5 new this year',
                  icon: Icons.people,
                  color: AppColors.warning,
                ),
                StatCard(
                  title: 'Completed',
                  value: '42',
                  subtitle: '87% success rate',
                  icon: Icons.check_circle,
                  color: AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Charts Section
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget Utilization',
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(
                          height: 200,
                          child: BudgetChart(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project Progress',
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(
                          height: 200,
                          child: ProjectProgressChart(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _QuickActionCard(
                  icon: Icons.add_business,
                  label: 'New Project',
                  onTap: () => context.push('/projects/create'),
                ),
                _QuickActionCard(
                  icon: Icons.people_alt,
                  label: 'Manage Partners',
                  onTap: () => context.push('/partners'),
                ),
                _QuickActionCard(
                  icon: Icons.assessment,
                  label: 'View Reports',
                  onTap: () => context.push('/reports'),
                ),
                _QuickActionCard(
                  icon: Icons.account_balance,
                  label: 'Budget Planning',
                  onTap: () => context.push('/budgets'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Activities
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activities',
                        style: AppTextStyles.titleMedium,
                      ),
                      TextButton(
                        onPressed: () => context.push('/activities'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const RecentActivities(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Pending Approvals
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pending Approvals',
                        style: AppTextStyles.titleMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '5',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _PendingApprovalItem(
                    title: 'Education Project Milestone',
                    subtitle: 'Submitted by Green Future Foundation',
                    time: '2 hours ago',
                    onTap: () => context.push('/approvals/1'),
                  ),
                  _PendingApprovalItem(
                    title: 'Budget Revision Request',
                    subtitle: 'Health Initiative - Rural Clinic',
                    time: '5 hours ago',
                    onTap: () => context.push('/approvals/2'),
                  ),
                  _PendingApprovalItem(
                    title: 'New Partner Application',
                    subtitle: 'Community Development Trust',
                    time: '1 day ago',
                    onTap: () => context.push('/approvals/3'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingApprovalItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback onTap;

  const _PendingApprovalItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}