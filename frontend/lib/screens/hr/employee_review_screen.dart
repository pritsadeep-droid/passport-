import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/kpi.dart';
import '../../models/milestone.dart';
import '../../models/probation_record.dart';
import '../../models/user.dart';
import '../../providers/probation_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/milestone_timeline.dart';
import '../../widgets/final_decision_dialog.dart';
import '../../widgets/supervisor_transfer_dialog.dart';
import '../../widgets/start_probation_dialog.dart';
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.person_search, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('ตรวจสอบการทดลองงาน'),
          ],
        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('กลับ'),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => _showStartProbationDialog(),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('เริ่มการทดลองงาน'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStartProbationDialog() {
    // We need employee name, which we might not have if record is null
    // But we have employeeId from widget.employeeId
    // Ideally we should fetch employee details first if record is null
    // For now let's use a placeholder or ID
    
    showStartProbationDialog(
      context: context,
      employeeName: 'รหัส ${widget.employeeId}', // TODO: Fetch name
      onStart: (supervisorId, startDate, probationDays, templateId) async {
        Navigator.of(context).pop();

        final success = await ref
            .read(probationRecordProvider(widget.employeeId).notifier)
            .createProbationRecord(
              employeeId: widget.employeeId,
              supervisorId: supervisorId,
              startDate: startDate,
              probationDays: probationDays,
              templateId: templateId,
            );
            
        if (mounted) {
          if (success != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('เริ่มการทดลองงานสำเร็จ')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ref.read(probationRecordProvider(widget.employeeId)).error ??
                  'เกิดข้อผิดพลาด',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, ProbationRecord record) {
    final employee = record.employee;
    final supervisor = record.supervisor;
    final milestones = record.milestones;
    final kpis = record.kpis;
    final status = record.status.name;
    final finalDecision = record.finalDecision;

    // Calculate stats
    final passedMilestones = milestones.where((m) => m.status == MilestoneStatus.passed).length;
    final failedMilestones = milestones.where((m) => m.status == MilestoneStatus.failed).length;
    final totalMilestones = milestones.length;

    // Calculate progress
    final now = DateTime.now();
    final startDate = record.startDate;
    final endDate = record.endDate;
    final totalDays = endDate.difference(startDate).inDays;
    final elapsedDays = now.difference(startDate).inDays;
    final remainingDays = endDate.difference(now).inDays.clamp(0, totalDays);
    final progressPercent = totalDays > 0 ? ((elapsedDays / totalDays) * 100).clamp(0, 100).round() : 0;

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
              'ไมล์สโตน',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            MilestoneTimeline(
              milestones: milestones,
              onMilestoneTap: (milestone) {
                context.push('/hr/milestone/${record.id}/${milestone.day}');
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(ThemeData theme, User? employee, User? supervisor, String status) {
    final employeeName = employee?.name ?? employee?.email ?? 'Unknown';
    final employeeDepartment = employee?.department;
    final supervisorName = supervisor?.name ?? supervisor?.email;

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
                    employeeName[0].toUpperCase(),
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
                        employeeName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (employeeDepartment != null)
                        Text(
                          employeeDepartment,
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
            if (supervisorName != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.supervisor_account, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'หัวหน้างาน: $supervisorName',
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

  Widget _buildFinalDecisionCard(ThemeData theme, FinalDecisionInfo finalDecision) {
    final decision = finalDecision.decision;
    final isPassed = decision == FinalDecision.passed;
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
            if (finalDecision.reason != null) ...[
              const SizedBox(height: 8),
              Text(
                'หมายเหตุ: ${finalDecision.reason}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (finalDecision.decidedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                'ตัดสินใจเมื่อ: ${_formatDate(finalDecision.decidedAt!)}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKpiList(ThemeData theme, List<Kpi> kpis) {
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
            title: Text(kpi.title),
            subtitle: kpi.description != null
                ? Text(
                    kpi.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ThemeData theme, ProbationRecord record) {
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

  bool _canMakeDecision(ProbationRecord record) {
    return record.status == ProbationStatus.pendingDecision;
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

  void _showFinalDecisionDialog(ProbationRecord record) {
    final employee = record.employee;
    final milestones = record.milestones;

    final passedMilestones = milestones.where((m) => m.status == MilestoneStatus.passed).length;
    final failedMilestones = milestones.where((m) => m.status == MilestoneStatus.failed).length;
    final totalMilestones = milestones.length;

    // Calculate average score
    double totalScore = 0;
    int scoreCount = 0;
    for (final m in milestones) {
      final score = m.supervisorAssessment?.averageScore;
      if (score != null) {
        totalScore += score;
        scoreCount++;
      }
    }
    final averageScore = scoreCount > 0 ? totalScore / scoreCount : null;

    showFinalDecisionDialog(
      context: context,
      employeeName: employee?.name ?? employee?.email ?? 'Unknown',
      passedMilestones: passedMilestones,
      failedMilestones: failedMilestones,
      totalMilestones: totalMilestones,
      averageScore: averageScore,
      onDecision: (decision, reason) async {
        Navigator.of(context).pop();

        final finalDecision = decision == 'passed'
            ? FinalDecision.passed
            : FinalDecision.failed;

        final result = await ref
            .read(probationRecordProvider(widget.employeeId).notifier)
            .makeFinalDecision(
              decision: finalDecision,
              reason: reason,
            );

        if (mounted) {
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(decision == 'passed'
                    ? 'บันทึกผลผ่านการทดลองงานสำเร็จ'
                    : 'บันทึกผลไม่ผ่านการทดลองงานสำเร็จ'),
                backgroundColor: decision == 'passed' ? Colors.green : null,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ref.read(probationRecordProvider(widget.employeeId)).error ??
                  'เกิดข้อผิดพลาดในการบันทึกผล',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      },
    );
  }

  void _showTransferDialog(ProbationRecord record) async {
    final employee = record.employee;
    final supervisor = record.supervisor;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Fetch supervisors list from API
    List<SupervisorOption> supervisors = [];
    try {
      final userService = ref.read(userServiceProvider);

      // Fetch both supervisors and hr_admins
      final supervisorResponse = await userService.getAllUsers(
        limit: 100,
        role: 'supervisor',
      );
      final hrResponse = await userService.getAllUsers(
        limit: 100,
        role: 'hr_admin',
      );

      final allUsers = [...supervisorResponse.data, ...hrResponse.data];
      supervisors = allUsers
          .map((u) => SupervisorOption(
                id: u.id,
                name: u.name,
                email: u.email,
                department: u.department,
              ))
          .toList();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ไม่สามารถโหลดรายชื่อหัวหน้างานได้: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop(); // Close loading dialog

    showSupervisorTransferDialog(
      context: context,
      employeeName: employee?.name ?? employee?.email ?? 'Unknown',
      currentSupervisorName: supervisor?.name ?? supervisor?.email ?? 'Unknown',
      currentSupervisorId: record.supervisorId,
      supervisors: supervisors,
      onTransfer: (newSupervisorId, reason) async {
        Navigator.of(context).pop();

        final result = await ref
            .read(probationRecordProvider(widget.employeeId).notifier)
            .transferSupervisor(
              newSupervisorId: newSupervisorId,
              reason: reason,
            );

        if (mounted) {
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('โอนย้ายหัวหน้างานสำเร็จ')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ref.read(probationRecordProvider(widget.employeeId)).error ??
                  'เกิดข้อผิดพลาดในการโอนย้าย',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      },
    );
  }

  void _showExtendDialog(ProbationRecord record) {
    final employee = record.employee;
    final endDate = record.endDate;

    showExtendProbationDialog(
      context: context,
      employeeName: employee?.name ?? employee?.email ?? 'Unknown',
      currentEndDate: endDate,
      onExtend: (additionalDays, reason) async {
        Navigator.of(context).pop();

        final result = await ref
            .read(probationRecordProvider(widget.employeeId).notifier)
            .extendProbation(
              additionalDays: additionalDays,
              reason: reason,
            );

        if (mounted) {
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ขยายเวลาทดลองงาน $additionalDays วันสำเร็จ')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ref.read(probationRecordProvider(widget.employeeId)).error ??
                  'เกิดข้อผิดพลาดในการขยายเวลา',
                ),
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
      case 'pendingKpi':
        return Colors.orange;
      case 'inProgress':
        return Colors.blue;
      case 'pendingDecision':
        return Colors.purple;
      case 'passed':
        return Colors.green;
      case 'failed':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pendingKpi':
        return 'รอกำหนด KPI';
      case 'inProgress':
        return 'กำลังทดลองงาน';
      case 'pendingDecision':
        return 'รอการตัดสินใจ';
      case 'passed':
        return 'ผ่านทดลองงาน';
      case 'failed':
        return 'ไม่ผ่าน';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
