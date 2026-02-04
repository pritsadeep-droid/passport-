import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/milestone_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/approval_buttons.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class PendingApprovalsScreen extends ConsumerStatefulWidget {
  const PendingApprovalsScreen({super.key});

  @override
  ConsumerState<PendingApprovalsScreen> createState() =>
      _PendingApprovalsScreenState();
}

class _PendingApprovalsScreenState
    extends ConsumerState<PendingApprovalsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pendingApprovalsProvider.notifier).loadPendingApprovals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pendingApprovalsProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'รออนุมัติ Milestone',
        showBackButton: true,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PendingApprovalsState state) {
    if (state.isLoading && state.approvals.isEmpty) {
      return LoadingWidget(message: 'กำลังโหลดข้อมูล...');
    }

    if (state.error != null && state.approvals.isEmpty) {
      return CustomErrorWidget(
        message: state.error!,
        onRetry: () =>
            ref.read(pendingApprovalsProvider.notifier).loadPendingApprovals(),
      );
    }

    if (state.approvals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'ไม่มีรายการรออนุมัติ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'คุณได้ดำเนินการครบทุกรายการแล้ว',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(pendingApprovalsProvider.notifier).loadPendingApprovals(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.approvals.length,
        itemBuilder: (context, index) {
          final approval = state.approvals[index];
          return PendingApprovalCard(
            employeeName: approval.employee.name ?? approval.employee.email ?? '',
            department: approval.employee.department,
            milestoneDay: approval.milestone.day,
            dueDate: approval.milestone.dueDate,
            onTap: () => context.push(
              '/supervisor/milestone-approval/${approval.probationRecordId}/${approval.milestone.day}',
            ),
          );
        },
      ),
    );
  }
}
