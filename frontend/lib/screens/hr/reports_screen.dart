import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/report_provider.dart';
import '../../services/report_service.dart';
import '../../utils/theme.dart';
import '../../widgets/loading.dart';
import '../../widgets/error_widget.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  // Filter state
  String? _selectedStatus;
  String? _selectedDepartment;
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedFormat = 'pdf';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportTypesProvider.notifier).load();
      ref.read(reportStatsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typesState = ref.watch(reportTypesProvider);
    final statsState = ref.watch(reportStatsProvider);
    final downloadState = ref.watch(reportDownloadProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายงาน'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(reportStatsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(reportStatsProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics summary
              if (statsState.isLoading)
                const Center(child: LoadingIndicator())
              else if (statsState.error != null)
                AppErrorWidget(
                  message: statsState.error!,
                  onRetry: () => ref.read(reportStatsProvider.notifier).load(),
                )
              else if (statsState.stats != null)
                _buildStatsSection(theme, statsState.stats!),

              const SizedBox(height: AppSpacing.lg),

              // Report types
              Text(
                'ประเภทรายงาน',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              if (typesState.isLoading)
                const Center(child: LoadingIndicator())
              else if (typesState.error != null)
                AppErrorWidget(
                  message: typesState.error!,
                  onRetry: () => ref.read(reportTypesProvider.notifier).load(),
                )
              else
                _buildReportCards(theme, typesState.types),

              // Download progress
              if (downloadState.isDownloading) ...[
                const SizedBox(height: AppSpacing.lg),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'กำลังสร้างรายงาน...',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme, ReportStats stats) {
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
                  'ภาพรวม',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'อัตราผ่าน ${stats.passRate.toStringAsFixed(1)}%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _buildStatItem(
                  theme,
                  'ทั้งหมด',
                  stats.total.toString(),
                  AppColors.primary,
                ),
                _buildStatItem(
                  theme,
                  'กำลังทดลอง',
                  stats.inProgress.toString(),
                  Colors.blue,
                ),
                _buildStatItem(
                  theme,
                  'ผ่าน',
                  stats.passed.toString(),
                  Colors.green,
                ),
                _buildStatItem(
                  theme,
                  'ไม่ผ่าน',
                  stats.failed.toString(),
                  Colors.red,
                ),
              ],
            ),
            if (stats.byDepartment.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'แยกตามแผนก',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...stats.byDepartment.take(5).map((dept) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dept.department,
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          '${dept.count} คน',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCards(ThemeData theme, List<ReportType> types) {
    return Column(
      children: [
        // Summary report card
        _buildReportCard(
          theme,
          icon: Icons.summarize,
          title: 'รายงานสรุปการทดลองงาน',
          description: 'สรุปภาพรวมพนักงานทดลองงานทั้งหมด',
          formats: ['pdf', 'xlsx'],
          hasFilters: true,
          onDownload: _downloadSummaryReport,
        ),

        const SizedBox(height: AppSpacing.sm),

        // Department report card
        _buildReportCard(
          theme,
          icon: Icons.apartment,
          title: 'รายงานแยกตามแผนก',
          description: 'รายงานสรุปแยกตามแผนก (Excel)',
          formats: ['xlsx'],
          hasFilters: false,
          onDownload: (_) => _downloadDepartmentReport(),
        ),
      ],
    );
  }

  Widget _buildReportCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    required List<String> formats,
    required bool hasFilters,
    required Function(String format) onDownload,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (hasFilters) {
            _showFilterDialog(theme, formats, onDownload);
          } else {
            onDownload(formats.first);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: formats
                          .map((f) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  f.toUpperCase(),
                                  style: theme.textTheme.labelSmall,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(
    ThemeData theme,
    List<String> formats,
    Function(String format) onDownload,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ตัวกรองรายงาน',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status filter
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'สถานะ',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('ทั้งหมด')),
                      DropdownMenuItem(
                          value: 'in_progress', child: Text('กำลังทดลองงาน')),
                      DropdownMenuItem(
                          value: 'pending_decision', child: Text('รอการตัดสิน')),
                      DropdownMenuItem(
                          value: 'passed', child: Text('ผ่านทดลองงาน')),
                      DropdownMenuItem(
                          value: 'failed', child: Text('ไม่ผ่านทดลองงาน')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Date range
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setDialogState(() {
                                _startDate = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'ตั้งแต่วันที่',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _startDate != null
                                  ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                  : 'เลือกวันที่',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setDialogState(() {
                                _endDate = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'ถึงวันที่',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _endDate != null
                                  ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                  : 'เลือกวันที่',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Format selection
                  Text(
                    'รูปแบบไฟล์',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: formats.map((format) {
                      final isSelected = _selectedFormat == format;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(format.toUpperCase()),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setDialogState(() {
                                _selectedFormat = format;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setDialogState(() {
                              _selectedStatus = null;
                              _selectedDepartment = null;
                              _startDate = null;
                              _endDate = null;
                              _selectedFormat = 'pdf';
                            });
                          },
                          child: const Text('ล้างตัวกรอง'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text('ดาวน์โหลด'),
                          onPressed: () {
                            Navigator.pop(context);
                            onDownload(_selectedFormat);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _downloadSummaryReport(String format) async {
    final filters = ReportFilters(
      status: _selectedStatus,
      department: _selectedDepartment,
      startDate: _startDate,
      endDate: _endDate,
      format: format,
    );

    final data =
        await ref.read(reportDownloadProvider.notifier).downloadSummaryReport(filters);

    if (data != null) {
      await _saveAndShareFile(data, 'probation-summary', format);
    } else {
      _showErrorSnackbar('ไม่สามารถดาวน์โหลดรายงานได้');
    }
  }

  Future<void> _downloadDepartmentReport() async {
    final data =
        await ref.read(reportDownloadProvider.notifier).downloadDepartmentReport();

    if (data != null) {
      await _saveAndShareFile(data, 'department-report', 'xlsx');
    } else {
      _showErrorSnackbar('ไม่สามารถดาวน์โหลดรายงานได้');
    }
  }

  Future<void> _saveAndShareFile(
    List<int> data,
    String filename,
    String format,
  ) async {
    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().split('T')[0];
      final file = File('${directory.path}/$filename-$timestamp.$format');
      await file.writeAsBytes(data);

      if (!mounted) return;

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'รายงานการทดลองงาน',
      );
    } catch (e) {
      _showErrorSnackbar('ไม่สามารถบันทึกไฟล์ได้: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
