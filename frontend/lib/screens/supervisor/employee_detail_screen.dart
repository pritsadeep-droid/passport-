import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/probation_record.dart';
import '../../models/milestone.dart';
import '../../providers/probation_provider.dart';
import '../../providers/kpi_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loading.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/kpi_card.dart';

class EmployeeDetailScreen extends ConsumerStatefulWidget {
  final String employeeId;

  const EmployeeDetailScreen({
    super.key,
    required this.employeeId,
  });

  @override
  ConsumerState<EmployeeDetailScreen> createState() =>
      _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends ConsumerState<EmployeeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load probation record
    Future.microtask(() {
      ref
          .read(probationDetailProvider(widget.employeeId).notifier)
          .loadRecord(widget.employeeId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(probationDetailProvider(widget.employeeId));

    return Scaffold(
      appBar: CustomAppBar(
        title: state.record?.employee?.name ?? 'รายละเอียดพนักงาน',
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'ภาพรวม'),
            Tab(text: 'KPI'),
          ],
        ),
      ),
      body: _buildContent(state),
      floatingActionButton: _buildFab(state),
    );
  }

  Widget _buildContent(ProbationDetailState state) {
    if (state.isLoading) {
      return const LoadingScreen(message: 'กำลังโหลด...');
    }

    if (state.error != null) {
      return ErrorDisplay(
        message: state.error!,
        onRetry: () => ref
            .read(probationDetailProvider(widget.employeeId).notifier)
            .loadRecord(widget.employeeId),
      );
    }

    final record = state.record;
    if (record == null) {
      return const ErrorDisplay(message: 'ไม่พบข้อมูล');
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _OverviewTab(record: record),
        _KpiTab(record: record),
      ],
    );
  }

  Widget? _buildFab(ProbationDetailState state) {
    final record = state.record;
    if (record == null) return null;

    // Show add KPI button if pending_kpi status
    if (record.status == ProbationStatus.pendingKpi) {
      return FloatingActionButton.extended(
        onPressed: () => context.push(
          '/supervisor/employee/${record.id}/kpi/create',
        ),
        icon: const Icon(Icons.add),
        label: const Text('กำหนด KPI'),
      );
    }

    return null;
  }
}

class _OverviewTab extends StatelessWidget {
  final ProbationRecord record;

  const _OverviewTab({required this.record});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee info card
          _buildEmployeeCard(),
          const SizedBox(height: AppSpacing.md),

          // Progress card
          _buildProgressCard(),
          const SizedBox(height: AppSpacing.md),

          // Milestones
          Text(
            'Milestones',
            style: AppTextStyles.headline3,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...record.milestones.map((m) => _MilestoneCard(milestone: m)),
          const SizedBox(height: AppSpacing.md),
          
          // Onboarding Section
          Consumer(
            builder: (context, ref, child) {
              final teamOnboarding = ref.watch(teamOnboardingProvider);
              return teamOnboarding.when(
                data: (instances) {
                  // Find instance for this employee
                  try {
                    // record.employee.id gives the User ID (mongo ID), record.id is Probation ID
                    // We need to match with instance.employeeId (which is User ID)
                    // record.employee is User object or just ID? In Frontend model ProbationRecord, employee is User object.
                    final user = record.employee;
                    if (user == null) return const SizedBox.shrink();

                    final instance = instances.firstWhere(
                      // instance.employeeId in frontend model is String (ID)
                      (i) => i.employeeId == user.id,
                    );
                    
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.rocket_launch, color: Colors.indigo),
                        title: const Text('Onboarding Mission'),
                        subtitle: Text('สถานะ: ${instance.status}'),
                        trailing: FilledButton(
                          onPressed: () => context.push('/supervisor/onboarding-review/${instance.id}'),
                          child: const Text('ตรวจสอบ'),
                        ),
                      ),
                    );
                  } catch (e) {
                    // Not found, show Assign button
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.rocket_launch, color: Colors.grey),
                        title: const Text('Onboarding Mission'),
                        subtitle: const Text('ยังไม่ได้เริ่ม'),
                        trailing: Consumer(
                          builder: (context, ref, child) {
                            return FilledButton(
                              onPressed: () async {
                                // Fetch templates
                                final templates = await ref.read(onboardingTemplatesProvider.future);
                                if (templates.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('ไม่พบ Template')),
                                  );
                                  return;
                                }
                                // For MVP, pick first template or show dialog
                                // Let's just pick first for simplicity if only 1, or dialog
                                if (context.mounted) {
                                   await ref.read(assignOnboardingProvider.notifier).assign(
                                    record.employee!.id, // User ID
                                    templates.first.id,
                                    DateTime.now(),
                                  );
                                  // Refresh team provider
                                  ref.refresh(teamOnboardingProvider);
                                }
                              },
                              child: const Text('เริ่ม Onboarding'),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard() {
    final employee = record.employee;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                _getInitials(employee?.name ?? ''),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee?.name ?? 'Unknown',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'รหัส: ${employee?.employeeId ?? ""}',
                    style: AppTextStyles.body2,
                  ),
                  Text(
                    'แผนก: ${employee?.department ?? ""}',
                    style: AppTextStyles.body2,
                  ),
                  Text(
                    'อีเมล: ${employee?.email ?? ""}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final daysRemaining = record.calculatedDaysRemaining;
    final progressPercentage = record.calculatedProgressPercentage;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ความคืบหน้า',
                  style: AppTextStyles.subtitle1,
                ),
                _StatusChip(status: record.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercentage / 100,
                backgroundColor: AppColors.surfaceVariant,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  icon: Icons.schedule,
                  label: 'เหลือ',
                  value: '$daysRemaining วัน',
                ),
                _StatItem(
                  icon: Icons.calendar_today,
                  label: 'ทดลองงาน',
                  value: '${record.probationDays} วัน',
                ),
                _StatItem(
                  icon: Icons.flag_outlined,
                  label: 'KPI',
                  value: '${record.kpis.length} ข้อ',
                ),
                _StatItem(
                  icon: Icons.check_circle_outline,
                  label: 'ผ่าน',
                  value:
                      '${record.passedMilestonesCount}/${record.milestones.length}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

class _KpiTab extends ConsumerWidget {
  final ProbationRecord record;

  const _KpiTab({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (record.kpis.isEmpty) {
      return EmptyKpiState(
        canAdd: record.status == ProbationStatus.pendingKpi,
        onAdd: () => context.push(
          '/supervisor/employee/${record.id}/kpi/create',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: record.kpis.length,
      itemBuilder: (context, index) {
        final kpi = record.kpis[index];
        return KpiCard(
          kpi: kpi,
          index: index,
          canEdit: record.status.isActive,
          onEdit: () {
            // TODO: Navigate to edit KPI
          },
          onDelete: () {
            // TODO: Delete KPI
          },
        );
      },
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final Milestone milestone;

  const _MilestoneCard({required this.milestone});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(milestone.status).withOpacity(0.1),
          child: Icon(
            _getStatusIcon(milestone.status),
            color: _getStatusColor(milestone.status),
          ),
        ),
        title: Text(milestone.displayLabel),
        subtitle: Text(
          milestone.status.displayName,
          style: TextStyle(color: _getStatusColor(milestone.status)),
        ),
        trailing: milestone.status.isUpcoming
            ? Text(
                'เหลือ ${milestone.daysRemaining} วัน',
                style: AppTextStyles.caption,
              )
            : null,
      ),
    );
  }

  Color _getStatusColor(MilestoneStatus status) {
    switch (status) {
      case MilestoneStatus.upcoming:
        return AppColors.textSecondary;
      case MilestoneStatus.pendingSelf:
      case MilestoneStatus.pendingSupervisor:
      case MilestoneStatus.pendingApproval:
        return AppColors.warning;
      case MilestoneStatus.passed:
        return AppColors.success;
      case MilestoneStatus.failed:
        return AppColors.error;
      case MilestoneStatus.overdue:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(MilestoneStatus status) {
    switch (status) {
      case MilestoneStatus.upcoming:
        return Icons.schedule;
      case MilestoneStatus.pendingSelf:
      case MilestoneStatus.pendingSupervisor:
      case MilestoneStatus.pendingApproval:
        return Icons.pending_actions;
      case MilestoneStatus.passed:
        return Icons.check_circle;
      case MilestoneStatus.failed:
        return Icons.cancel;
      case MilestoneStatus.overdue:
        return Icons.warning;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final ProbationStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: AppTextStyles.caption.copyWith(
          color: _getColor(status),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getColor(ProbationStatus status) {
    switch (status) {
      case ProbationStatus.pendingKpi:
        return AppColors.warning;
      case ProbationStatus.inProgress:
        return AppColors.info;
      case ProbationStatus.pendingDecision:
        return AppColors.primary;
      case ProbationStatus.passed:
        return AppColors.success;
      case ProbationStatus.failed:
      case ProbationStatus.terminated:
        return AppColors.error;
      case ProbationStatus.resigned:
        return AppColors.textSecondary;
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.subtitle1,
        ),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
