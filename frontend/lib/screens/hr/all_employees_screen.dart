import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/hr_dashboard_provider.dart';
import '../../widgets/employee_status_list.dart';

/// All employees screen for HR
class AllEmployeesScreen extends ConsumerStatefulWidget {
  /// Initial status filter from route
  final String? initialStatus;

  /// Initial department filter from route
  final String? initialDepartment;

  const AllEmployeesScreen({
    super.key,
    this.initialStatus,
    this.initialDepartment,
  });

  @override
  ConsumerState<AllEmployeesScreen> createState() => _AllEmployeesScreenState();
}

class _AllEmployeesScreenState extends ConsumerState<AllEmployeesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(allEmployeesProvider.notifier);

      // Apply initial filters
      if (widget.initialStatus != null) {
        notifier.setStatusFilter(widget.initialStatus);
      } else if (widget.initialDepartment != null) {
        notifier.setDepartmentFilter(widget.initialDepartment);
      } else {
        notifier.loadEmployees(refresh: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(allEmployeesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(allEmployeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('พนักงานทั้งหมด'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: _hasFilters(state) ? theme.colorScheme.primary : null,
            ),
            tooltip: 'กรอง',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาพนักงาน...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          ref.read(allEmployeesProvider.notifier).setSearchQuery(null);
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              ),
              onSubmitted: (value) {
                ref.read(allEmployeesProvider.notifier).setSearchQuery(
                    value.isEmpty ? null : value);
              },
            ),
          ),

          // Filters
          if (_showFilters) _buildFilters(theme, state),

          // Active filters chips
          if (_hasFilters(state)) _buildActiveFilters(theme, state),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'พบ ${state.total} รายการ',
                  style: theme.textTheme.bodySmall,
                ),
                if (state.isLoading && state.employees.isNotEmpty)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(allEmployeesProvider.notifier).loadEmployees(refresh: true);
              },
              child: _buildList(theme, state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(ThemeData theme, AllEmployeesState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สถานะ',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          EmployeeStatusFilterChips(
            selectedStatus: state.statusFilter,
            onStatusSelected: (status) {
              ref.read(allEmployeesProvider.notifier).setStatusFilter(status);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'แผนก',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _buildDepartmentDropdown(theme, state),
        ],
      ),
    );
  }

  Widget _buildDepartmentDropdown(ThemeData theme, AllEmployeesState state) {
    // This would ideally come from an API
    final departments = [
      'ทั้งหมด',
      'IT',
      'HR',
      'Finance',
      'Marketing',
      'Operations',
      'Sales',
    ];

    return DropdownButtonFormField<String?>(
      value: state.departmentFilter,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      hint: const Text('เลือกแผนก'),
      items: departments.map((dept) {
        return DropdownMenuItem(
          value: dept == 'ทั้งหมด' ? null : dept,
          child: Text(dept),
        );
      }).toList(),
      onChanged: (value) {
        ref.read(allEmployeesProvider.notifier).setDepartmentFilter(value);
      },
    );
  }

  Widget _buildActiveFilters(ThemeData theme, AllEmployeesState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          if (state.statusFilter != null)
            Chip(
              label: Text(_getStatusLabel(state.statusFilter!)),
              onDeleted: () {
                ref.read(allEmployeesProvider.notifier).setStatusFilter(null);
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          if (state.departmentFilter != null)
            Chip(
              label: Text(state.departmentFilter!),
              onDeleted: () {
                ref.read(allEmployeesProvider.notifier).setDepartmentFilter(null);
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          if (state.searchQuery != null)
            Chip(
              label: Text('ค้นหา: ${state.searchQuery}'),
              onDeleted: () {
                _searchController.clear();
                ref.read(allEmployeesProvider.notifier).setSearchQuery(null);
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          TextButton(
            onPressed: () {
              _searchController.clear();
              ref.read(allEmployeesProvider.notifier).clearFilters();
            },
            child: const Text('ล้างตัวกรอง'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(ThemeData theme, AllEmployeesState state) {
    if (state.isLoading && state.employees.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.employees.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'เกิดข้อผิดพลาด',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ref.read(allEmployeesProvider.notifier).loadEmployees(refresh: true);
                },
                child: const Text('ลองใหม่'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.employees.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 48,
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'ไม่พบพนักงาน',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'ลองเปลี่ยนตัวกรองหรือคำค้นหา',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.employees.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.employees.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final employee = state.employees[index];
        return EmployeeStatusItem(
          employee: employee,
          onTap: () {
            context.push('/hr/employee/${employee.id}/review');
          },
        );
      },
    );
  }

  bool _hasFilters(AllEmployeesState state) {
    return state.statusFilter != null ||
        state.departmentFilter != null ||
        state.searchQuery != null;
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending_kpi':
        return 'รอกำหนด KPI';
      case 'in_progress':
        return 'กำลังทดลองงาน';
      case 'passed':
        return 'ผ่านทดลองงาน';
      case 'failed':
        return 'ไม่ผ่าน';
      case 'pending_decision':
        return 'รอการตัดสินใจ';
      default:
        return status;
    }
  }
}
