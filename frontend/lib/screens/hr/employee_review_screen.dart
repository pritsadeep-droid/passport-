import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/probation_provider.dart';
import '../../widgets/milestone_timeline.dart';
import '../../widgets/final_decision_dialog.dart';
import '../../widgets/supervisor_transfer_dialog.dart';
import '../../widgets/stats_card.dart';

/// HR Employee Review screen
class EmployeeReviewScreen extends ConsumerStatefulWidget {
  /// Employee/Record ID
  final String employeeId;

  const EmployeeReviewScreen({
    super.key,
    required this.employeeId,
  });

  @override
  ConsumerState<EmployeeReviewScreen> createState() => _EmployeeReviewScreenState();
}

class _EmployeeReviewScreenState extends ConsumerState<EmployeeReviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(probationRecordProvider(widget.employeeId).notifier).loadRecord();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(probationRecordProvider(widget.employeeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตรวจสอบการทดลองงาน'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'transfer',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz),
                    SizedBox(width: 8),
                    Text('โอนย้ายหัวหน้างาน'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'extend',
                child: Row(
                  children: [
                    Icon(Icons.event_note),
                    SizedBox(width: 8),
                    Text('ขยายเวลาทดลองงาน'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? _buildError(state.error!, theme)
              : state.record == null
                  ? _buildNotFound(theme)
                  : _buildContent(context, theme, state.record!),
      bottomNavigationBar: state.record != null && _canMakeDecision(state.record!)
          ? _buildBottomBar(context, theme, state.record!)
          : null,
    );
  }

  Widget _buildError(String error, ThemeData theme) {
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
            Text('เกิดข้อผิดพลาด', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ref.read(probationRecordProvider(widget.employeeId).notifier).loadRecord();
              },
              child: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFound(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text('ไม่พบข้อมูล', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('ไม่พบข้อมูลการทดลองงานสำหรับพนักงานนี้'),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('กลับ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, record) {
    final employee = record['employeeId'];
    final supervisor = record['supervisorId'];
    final milestones = record['milestones'] as List? ?? [];
    final kpis = record['kpis'] as List? ?? [];
    final status = record['status'] ?? '';
    final finalDecision = record['finalDecision'];

    // Calculate stats
    final passedMilestones = milestones.where((m) => m['status'] == 'passed').length;
    final failedMilestones = milestones.where((m) => m['status'] == 'failed').length;
    final totalMilestones = milestones.length;

    // Calculate progress
    final now = DateTime.now();
    final startDate = DateTime.parse(record['startDate']);
    final endDate = DateTime.parse(record['endDate']);
    final totalDays = endDate.difference(startDate).inDays;
    final elapsedDays = now.difference(startDate).inDays;
    final remainingDays = endDate.difference(now).inDays.clamp(0, totalDays);
    final progressPercent = ((elapsedDays / totalDays) * 100).clamp(0, 100).round();

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(probationRecordProvider(widget.employeeId).notifier).loadRecord();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee info card
            _buildEmployeeCard(theme, employee, supervisor, status),
            const SizedBox(height: 16),

            // Progress card
            _buildProgressCard(
              theme,
              remainingDays,
              progressPercent,
              passedMilestones,
              failedMilestones,
              totalMilestones,
            ),
            const SizedBox(height: 24),

            // Final decision info
            if (finalDecision != null) ...[
              _buildFinalDecisionCard(theme, finalDecision),
              const SizedBox(height: 24),
            ],

            // KPIs
            if (kpis.isNotEmpty) ...[
              Text(
                'KPI (${kpis.length} ข้อ)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildKpiList(theme, kpis),
              const SizedBox(height: 24),
            ],

            // Milestones
            Text(
              'Milestones',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            MilestoneTimeline(
              milestones: milestones.map((m) {
                return MilestoneData(
                  day: m['day'] ?? 0,
                  status: m['status'] ?? 'upcoming',
                  dueDate: DateTime.tryParse(m['dueDate'] ?? '') ?? DateTime.now(),
                  selfScore: (m['selfAssessment']?['averageScore'] as num?)?.toDouble(),
                  supervisorScore: (m['supervisorAssessment']?['averageScore'] as num?)?.toDouble(),
                );
              }).toList(),
              onMilestoneTap: (day) {
                context.push('/hr/milestone/${record['_id']}/$day');
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(ThemeData theme, employee, supervisor, String status) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    (employee?['name'] ?? employee?['email'] ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee?['name'] ?? employee?['email'] ?? 'Unknown',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (employee?['department'] != null)
                        Text(
                          employee['department'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildStatusBadge(theme, status),
              ],
            ),
            if (supervisor != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.supervisor_account, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'หัวหน้างาน: ${supervisor['name'] ?? supervisor['email']}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, String status) {
    final color = _getStatusColor(theme, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _getStatusText(status),
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    ThemeData theme,
    int remainingDays,
    int progressPercent,
    int passed,
    int failed,
    int total,
  ) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InlineStat(
              label: 'วันที่เหลือ',
              value: '$remainingDays',
              icon: Icons.schedule,
              color: remainingDays <= 7
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
            InlineStat(
              label: 'ความคืบหน้า',
              value: '$progressPercent%',
              icon: Icons.trending_up,
              color: theme.colorScheme.primary,
            ),
            InlineStat(
              label: 'Milestone ผ่าน',
              value: '$passed/$total',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            InlineStat(
              label: 'Milestone ไม่ผ่าน',
              value: '$failed/$total',
              icon: Icons.cancel,
              color: failed > 0 ? theme.colorScheme.error : theme.colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalDecisionCard(ThemeData theme, finalDecision) {
    final decision = finalDecision['decision'];
    final isPassed = decision == 'passed';
    final color = isPassed ? Colors.green : theme.colorScheme.error;

    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPassed ? Icons.celebration : Icons.cancel,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  isPassed ? 'ผ่านการทดลองงาน' : 'ไม่ผ่านการทดลองงาน',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (finalDecision['reason'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'หมายเหตุ: ${finalDecision['reason']}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (finalDecision['decidedAt'] != null) ...[
              const SizedBox(height: 4),
              Text(
                'ตัดสินใจเมื่อ: ${_formatDate(DateTime.parse(finalDecision['decidedAt']))}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKpiList(ThemeData theme, List kpis) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text('${index + 1}'),
            ),
            title: Text(kpi['title'] ?? ''),
            subtitle: kpi['description'] != null
                ? Text(
                    kpi['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ThemeData theme, record) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleMenuAction('extend'),
                icon: const Icon(Icons.event_note),
                label: const Text('ขยายเวลา'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: () => _showFinalDecisionDialog(record),
                icon: const Icon(Icons.gavel),
                label: const Text('ตัดสินใจ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canMakeDecision(record) {
    final status = record['status'] ?? '';
    return ['pending_decision', 'extended'].contains(status);
  }

  void _handleMenuAction(String action) {
    final state = ref.read(probationRecordProvider(widget.employeeId));
    final record = state.record;
    if (record == null) return;

    switch (action) {
      case 'transfer':
        _showTransferDialog(record);
        break;
      case 'extend':
        _showExtendDialog(record);
        break;
    }
  }

  void _showFinalDecisionDialog(record) {
    final employee = record['employeeId'];
    final milestones = record['milestones'] as List? ?? [];

    final passedMilestones = milestones.where((m) => m['status'] == 'passed').length;
    final failedMilestones = milestones.where((m) => m['status'] == 'failed').length;
    final totalMilestones = milestones.length;

    // Calculate average score
    double totalScore = 0;
    int scoreCount = 0;
    for (final m in milestones) {
      final score = m['supervisorAssessment']?['averageScore'];
      if (score != null) {
        totalScore += (score as num).toDouble();
        scoreCount++;
      }
    }
    final averageScore = scoreCount > 0 ? totalScore / scoreCount : null;

    showFinalDecisionDialog(
      context: context,
      employeeName: employee?['name'] ?? employee?['email'] ?? 'Unknown',
      passedMilestones: passedMilestones,
      failedMilestones: failedMilestones,
      totalMilestones: totalMilestones,
      averageScore: averageScore,
      onDecision: (decision, reason) async {
        Navigator.of(context).pop();

        try {
          await ref.read(probationRecordProvider(widget.employeeId).notifier)
              .updateStatus(decision, reason: reason);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(decision == 'passed'
                    ? 'บันทึกผลผ่านการทดลองงานสำเร็จ'
                    : 'บันทึกผลไม่ผ่านการทดลองงานสำเร็จ'),
                backgroundColor: decision == 'passed' ? Colors.green : null,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('เกิดข้อผิดพลาด: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      },
    );
  }

  void _showTransferDialog(record) {
    final employee = record['employeeId'];
    final supervisor = record['supervisorId'];

    // TODO: Fetch supervisors list from API
    final supervisors = <SupervisorOption>[
      SupervisorOption(id: '1', name: 'Manager A', email: 'managera@example.com', department: 'IT'),
      SupervisorOption(id: '2', name: 'Manager B', email: 'managerb@example.com', department: 'HR'),
    ];

    showSupervisorTransferDialog(
      context: context,
      employeeName: employee?['name'] ?? employee?['email'] ?? 'Unknown',
      currentSupervisorName: supervisor?['name'] ?? supervisor?['email'] ?? 'Unknown',
      currentSupervisorId: supervisor?['_id'] ?? '',
      supervisors: supervisors,
      onTransfer: (newSupervisorId, reason) async {
        Navigator.of(context).pop();

        try {
          await ref.read(probationRecordProvider(widget.employeeId).notifier)
              .transferSupervisor(newSupervisorId, reason);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('โอนย้ายหัวหน้างานสำเร็จ')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('เกิดข้อผิดพลาด: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      },
    );
  }

  void _showExtendDialog(record) {
    final employee = record['employeeId'];
    final endDate = DateTime.parse(record['endDate']);

    showExtendProbationDialog(
      context: context,
      employeeName: employee?['name'] ?? employee?['email'] ?? 'Unknown',
      currentEndDate: endDate,
      onExtend: (additionalDays, reason) async {
        Navigator.of(context).pop();

        try {
          // TODO: Implement extend API call
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ขยายเวลาทดลองงาน $additionalDays วันสำเร็จ')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('เกิดข้อผิดพลาด: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      },
    );
  }

  Color _getStatusColor(ThemeData theme, String status) {
    switch (status) {
      case 'pending_kpi':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'pending_decision':
        return Colors.purple;
      case 'passed':
        return Colors.green;
      case 'failed':
        return theme.colorScheme.error;
      case 'extended':
        return Colors.indigo;
      default:
        return theme.colorScheme.outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending_kpi':
        return 'รอกำหนด KPI';
      case 'in_progress':
        return 'กำลังทดลองงาน';
      case 'pending_decision':
        return 'รอการตัดสินใจ';
      case 'passed':
        return 'ผ่านทดลองงาน';
      case 'failed':
        return 'ไม่ผ่าน';
      case 'extended':
        return 'ขยายเวลา';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
