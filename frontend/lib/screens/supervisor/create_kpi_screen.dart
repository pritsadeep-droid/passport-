import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/kpi.dart';
import '../../providers/kpi_provider.dart';
import '../../providers/probation_provider.dart';
import '../../services/kpi_service.dart';
import '../../utils/theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loading.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/kpi_form.dart';
import '../../widgets/kpi_card.dart';

class CreateKpiScreen extends ConsumerStatefulWidget {
  final String probationRecordId;

  const CreateKpiScreen({
    super.key,
    required this.probationRecordId,
  });

  @override
  ConsumerState<CreateKpiScreen> createState() => _CreateKpiScreenState();
}

class _CreateKpiScreenState extends ConsumerState<CreateKpiScreen> {
  final List<CreateKpiRequest> _kpis = [];
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'กำหนด KPI',
        logoIcon: Icons.flag,
        actions: [
          if (_kpis.isNotEmpty)
            TextButton(
              onPressed: _canSave ? _handleSave : null,
              child: const Text(
                'บันทึก',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isSaving,
        message: 'กำลังบันทึก...',
        child: Column(
          children: [
            // KPI count indicator
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: KpiCountIndicator(
                count: _kpis.length,
                minCount: KpiService.minKpis,
                maxCount: KpiService.maxKpis,
              ),
            ),

            // Instructions
            if (_kpis.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Card(
                  color: AppColors.info.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.info),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'กรุณาเพิ่ม KPI อย่างน้อย ${KpiService.minKpis} ข้อ สำหรับพนักงานใหม่',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // KPI list
            Expanded(
              child: _kpis.isEmpty
                  ? _buildEmptyState()
                  : _buildKpiList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _kpis.length < KpiService.maxKpis
          ? FloatingActionButton(
              onPressed: _showAddKpiForm,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  bool get _canSave =>
      _kpis.length >= KpiService.minKpis &&
      _kpis.length <= KpiService.maxKpis;

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'ยังไม่มี KPI',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'กดปุ่ม + เพื่อเพิ่ม KPI',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: _showAddKpiForm,
            icon: const Icon(Icons.add),
            label: const Text('เพิ่ม KPI'),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.only(
        bottom: 100,
        top: AppSpacing.sm,
      ),
      itemCount: _kpis.length,
      onReorder: _handleReorder,
      itemBuilder: (context, index) {
        final kpi = _kpis[index];
        return _KpiDraftCard(
          key: ValueKey(index),
          kpi: kpi,
          index: index,
          onEdit: () => _showEditKpiForm(index),
          onDelete: () => _handleDelete(index),
        );
      },
    );
  }

  void _showAddKpiForm() async {
    final result = await KpiFormBottomSheet.show(context);
    if (result != null) {
      setState(() {
        _kpis.add(result);
      });
    }
  }

  void _showEditKpiForm(int index) async {
    final currentKpi = _kpis[index];
    final result = await KpiFormBottomSheet.show(
      context,
      initialKpi: Kpi(
        id: index.toString(),
        title: currentKpi.title,
        description: currentKpi.description,
        criteria: currentKpi.criteria,
      ),
      showDelete: true,
      onDelete: () => _handleDelete(index),
    );

    if (result != null) {
      setState(() {
        _kpis[index] = result;
      });
    }
  }

  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _kpis.removeAt(oldIndex);
      _kpis.insert(newIndex, item);
    });
  }

  void _handleDelete(int index) {
    setState(() {
      _kpis.removeAt(index);
    });
  }

  Future<void> _handleSave() async {
    if (!_canSave) {
      showErrorSnackBar(
        context,
        'ต้องมี KPI อย่างน้อย ${KpiService.minKpis} ข้อ',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final kpiNotifier =
          ref.read(kpiProvider(widget.probationRecordId).notifier);

      // First load KPIs to set the probation record ID
      await kpiNotifier.loadKpis(widget.probationRecordId);

      // Then create KPIs
      final success = await kpiNotifier.createKpis(_kpis);

      if (success) {
        // Refresh probation list
        ref.read(teamProbationProvider.notifier).refresh();

        if (mounted) {
          showSuccessSnackBar(context, 'สร้าง KPI สำเร็จ');
          context.pop();
        }
      } else {
        final error = ref.read(kpiProvider(widget.probationRecordId)).error;
        if (mounted && error != null) {
          showErrorSnackBar(context, error);
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

class _KpiDraftCard extends StatelessWidget {
  final CreateKpiRequest kpi;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KpiDraftCard({
    super.key,
    required this.kpi,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Drag handle
                  ReorderableDragStartListener(
                    index: index,
                    child: const Icon(
                      Icons.drag_handle,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  // Number
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Title
                  Expanded(
                    child: Text(
                      kpi.title,
                      style: AppTextStyles.subtitle1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Actions
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                    tooltip: 'แก้ไข',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      color: AppColors.error,
                    ),
                    onPressed: onDelete,
                    tooltip: 'ลบ',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Description preview
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Text(
                  kpi.description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
