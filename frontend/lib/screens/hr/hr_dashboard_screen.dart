import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/hr_dashboard_provider.dart' as provider;
import '../../services/dashboard_service.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/bottleneck_card.dart';
import '../../widgets/notification_badge.dart';

/// HR Dashboard screen
class HRDashboardScreen extends ConsumerStatefulWidget {
  const HRDashboardScreen({super.key});

  @override
  ConsumerState<HRDashboardScreen> createState() => _HRDashboardScreenState();
}

class _HRDashboardScreenState extends ConsumerState<HRDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(provider.hrDashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(provider.hrDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HR Dashboard'),
        actions: [
          NotificationIconBadge(
            onTap: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(provider.hrDashboardProvider.notifier).refresh();
        },
        child: state.isLoading && state.data == null
            ? const Center(child: CircularProgressIndicator())
            : state.error != null && state.data == null
                ? _buildErrorState(state.error!, theme)
                : _buildContent(context, theme, state.data!),
      ),
    );
  }

  Widget _buildErrorState(String error, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'เกิดข้อผิดพลาด',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref.read(provider.hrDashboardProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, HrDashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Stats
          _buildSummaryStats(context, theme, data),
          const SizedBox(height: 24),

          // Pass Rate
          _buildPassRateCard(context, theme, data),
          const SizedBox(height: 24),

          // Bottlenecks
          _buildBottlenecksSection(context, theme, data),
          const SizedBox(height: 24),

          // Pending Decisions
          if (data.pendingDecisions.isNotEmpty) ...[
            _buildPendingDecisionsSection(context, theme, data),
            const SizedBox(height: 24),
          ],

          // Department Summary
          _buildDepartmentSummary(context, theme, data),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(BuildContext context, ThemeData theme, HrDashboardData data) {
    final stats = data.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ภาพรวม',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        StatsGrid(
          stats: [
            StatData(
              title: 'ทั้งหมด',
              value: '${stats.total}',
              icon: Icons.people,
              color: theme.colorScheme.primaryContainer,
              onTap: () => context.push('/hr/employees'),
            ),
            StatData(
              title: 'กำลังทดลองงาน',
              value: '${stats.inProgress}',
              icon: Icons.hourglass_empty,
              color: Colors.blue.shade50,
              textColor: Colors.blue.shade700,
              onTap: () => context.push('/hr/employees?status=in_progress'),
            ),
            StatData(
              title: 'รอกำหนด KPI',
              value: '${stats.pendingKpi}',
              icon: Icons.assignment_late,
              color: Colors.orange.shade50,
              textColor: Colors.orange.shade700,
              onTap: () => context.push('/hr/employees?status=pending_kpi'),
            ),
            StatData(
              title: 'รอการตัดสินใจ',
              value: '${stats.pendingDecision}',
              icon: Icons.pending_actions,
              color: Colors.purple.shade50,
              textColor: Colors.purple.shade700,
              onTap: () => context.push('/hr/employees?status=pending_decision'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassRateCard(BuildContext context, ThemeData theme, HrDashboardData data) {
    final passRate = data.passRate;
    final passed = data.stats.passed;
    final failed = data.stats.failed;
    final total = passed + failed;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            PassRateIndicator(passRate: passRate),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'อัตราผ่านทดลองงาน',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildMiniStat(
                        theme,
                        'ผ่าน',
                        '$passed',
                        Colors.green,
                      ),
                      const SizedBox(width: 24),
                      _buildMiniStat(
                        theme,
                        'ไม่ผ่าน',
                        '$failed',
                        theme.colorScheme.error,
                      ),
                      const SizedBox(width: 24),
                      _buildMiniStat(
                        theme,
                        'รวม',
                        '$total',
                        theme.colorScheme.outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBottlenecksSection(BuildContext context, ThemeData theme, HrDashboardData data) {
    // Convert from dashboard_service.BottleneckItem to provider.BottleneckItem
    final bottlenecks = data.bottlenecks.map((b) => provider.BottleneckItem(
      type: b.type,
      severity: b.type == 'kpi_not_assigned' || b.type == 'ending_soon_incomplete' ? 'critical' : 'warning',
      recordId: b.probationRecordId,
      employeeId: b.employee.id,
      employeeName: b.employee.name ?? b.employee.email ?? 'Unknown',
      department: b.employee.department,
      supervisorName: b.supervisor?.name,
      message: _getBottleneckMessage(b),
      milestoneDay: b.milestone != null ? ((b.milestone as Map<String, dynamic>)['day'] as int?) : null,
      daysOverdue: b.milestone != null ? ((b.milestone as Map<String, dynamic>)['daysOverdue'] as int?) : null,
      daysPending: b.daysSinceStart,
    )).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ปัญหาที่ต้องดำเนินการ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            BottleneckSummaryChip(
              criticalCount: bottlenecks.where((b) => b.isCritical).length,
              warningCount: bottlenecks.where((b) => !b.isCritical).length,
            ),
          ],
        ),
        const SizedBox(height: 12),
        BottleneckList(
          bottlenecks: bottlenecks,
          onItemTap: (bottleneck) {
            context.push('/hr/employee/${bottleneck.employeeId}/review');
          },
          maxItems: 5,
          onSeeAll: () {
            // Navigate to bottlenecks list
          },
        ),
      ],
    );
  }

  String _getBottleneckMessage(BottleneckItem b) {
    switch (b.type) {
      case 'kpi_not_assigned':
        return 'ยังไม่ได้กำหนด KPI (${b.daysSinceStart ?? 0} วันแล้ว)';
      case 'milestone_overdue':
        final milestone = b.milestone as Map<String, dynamic>?;
        final day = milestone?['day'] ?? 0;
        final daysOverdue = milestone?['daysOverdue'] ?? 0;
        return 'Milestone วันที่ $day ค้างอยู่ $daysOverdue วัน';
      case 'pending_approval':
        final milestone = b.milestone as Map<String, dynamic>?;
        final day = milestone?['day'] ?? 0;
        return 'Milestone วันที่ $day รออนุมัติ';
      case 'ending_soon_incomplete':
        return 'ใกล้สิ้นสุดทดลองงานแต่ยังไม่เสร็จสมบูรณ์';
      default:
        return 'มีปัญหาที่ต้องดำเนินการ';
    }
  }

  Widget _buildPendingDecisionsSection(BuildContext context, ThemeData theme, HrDashboardData data) {
    final pending = data.pendingDecisions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'รอการตัดสินใจ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/hr/employees?status=pending_decision'),
              child: const Text('ดูทั้งหมด'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pending.length > 5 ? 5 : pending.length,
          itemBuilder: (context, index) {
            final item = pending[index];
            final employee = item.employee;
            final daysRemaining = item.daysRemaining;

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () => context.push('/hr/employee/${item.id}/review'),
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    (employee.name ?? employee.email ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                title: Text(employee.name ?? employee.email ?? 'Unknown'),
                subtitle: Text(employee.department ?? ''),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: daysRemaining <= 3
                        ? theme.colorScheme.errorContainer
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'เหลือ $daysRemaining วัน',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: daysRemaining <= 3
                          ? theme.colorScheme.error
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDepartmentSummary(BuildContext context, ThemeData theme, HrDashboardData data) {
    final departments = data.byDepartment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'สรุปตามแผนก',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: departments.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final entry = departments.entries.elementAt(index);
              final dept = entry.key;
              final stats = entry.value;

              return ListTile(
                onTap: () => context.push('/hr/employees?department=$dept'),
                title: Text(dept),
                subtitle: Text(
                  '${stats.total} คน (${stats.inProgress} กำลังทดลอง)',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (stats.passed > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${stats.passed} ผ่าน',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    if (stats.failed > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${stats.failed} ไม่ผ่าน',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
