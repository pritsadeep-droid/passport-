import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/probation_record.dart';
import '../../providers/probation_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loading.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/employee_list_item.dart';

class TeamListScreen extends ConsumerStatefulWidget {
  const TeamListScreen({super.key});

  @override
  ConsumerState<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends ConsumerState<TeamListScreen> {
  ProbationStatus? _selectedStatus;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load team records on init
    Future.microtask(() {
      ref.read(teamProbationProvider.notifier).loadRecords();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onStatusFilterChanged(ProbationStatus? status) {
    setState(() {
      _selectedStatus = status;
    });
    ref.read(teamProbationProvider.notifier).loadRecords(
          status: status,
          search: _searchController.text,
        );
  }

  void _onSearch(String query) {
    ref.read(teamProbationProvider.notifier).loadRecords(
          status: _selectedStatus,
          search: query,
        );
  }

  void _onEmployeeTap(ProbationRecord record) {
    context.push('/supervisor/employee/${record.employeeId}');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamProbationProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'พนักงานในทีม',
        logoIcon: Icons.people,
        showBackButton: false,
        onNotificationTap: () => context.push('/notifications'),
      ),
      body: Column(
        children: [
          // Search and filter bar
          _buildSearchBar(),
          _buildStatusFilter(),

          // List
          Expanded(
            child: _buildContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ค้นหาพนักงาน...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                )
              : null,
        ),
        onChanged: _onSearch,
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _FilterChip(
            label: 'ทั้งหมด',
            isSelected: _selectedStatus == null,
            onTap: () => _onStatusFilterChanged(null),
          ),
          _FilterChip(
            label: 'รอ KPI',
            isSelected: _selectedStatus == ProbationStatus.pendingKpi,
            onTap: () => _onStatusFilterChanged(ProbationStatus.pendingKpi),
            color: AppColors.warning,
          ),
          _FilterChip(
            label: 'กำลังดำเนินการ',
            isSelected: _selectedStatus == ProbationStatus.inProgress,
            onTap: () => _onStatusFilterChanged(ProbationStatus.inProgress),
            color: AppColors.info,
          ),
          _FilterChip(
            label: 'รอตัดสินใจ',
            isSelected: _selectedStatus == ProbationStatus.pendingDecision,
            onTap: () => _onStatusFilterChanged(ProbationStatus.pendingDecision),
            color: AppColors.primary,
          ),
          _FilterChip(
            label: 'ผ่าน',
            isSelected: _selectedStatus == ProbationStatus.passed,
            onTap: () => _onStatusFilterChanged(ProbationStatus.passed),
            color: AppColors.success,
          ),
          _FilterChip(
            label: 'ไม่ผ่าน',
            isSelected: _selectedStatus == ProbationStatus.failed,
            onTap: () => _onStatusFilterChanged(ProbationStatus.failed),
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProbationListState state) {
    if (state.isLoading && state.records.isEmpty) {
      return const SkeletonList();
    }

    if (state.error != null && state.records.isEmpty) {
      return ErrorDisplay(
        message: state.error!,
        onRetry: () => ref.read(teamProbationProvider.notifier).refresh(),
      );
    }

    if (state.records.isEmpty) {
      return EmptyEmployeeList(
        message: _selectedStatus != null
            ? 'ไม่พบพนักงานในสถานะนี้'
            : 'ยังไม่มีพนักงานในทีม',
        subtitle: 'พนักงานใหม่ที่คุณดูแลจะแสดงที่นี่',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(teamProbationProvider.notifier).refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 200) {
            ref.read(teamProbationProvider.notifier).loadMore();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.xxl,
          ),
          itemCount: state.records.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.records.length) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Center(child: LoadingIndicator()),
              );
            }

            final record = state.records[index];
            return EmployeeListItem(
              record: record,
              onTap: () => _onEmployeeTap(record),
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: chipColor.withOpacity(0.2),
        checkmarkColor: chipColor,
        labelStyle: TextStyle(
          color: isSelected ? chipColor : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
