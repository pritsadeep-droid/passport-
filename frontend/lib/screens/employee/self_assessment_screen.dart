import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/probation_record.dart';
import '../../providers/self_assessment_provider.dart';
import '../../services/local_storage.dart';
import '../../services/milestone_service.dart';
import '../../utils/theme.dart';
import '../../widgets/assessment_category_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/rating_scale.dart';

class SelfAssessmentScreen extends ConsumerStatefulWidget {
  final String recordId;
  final int day;

  const SelfAssessmentScreen({
    super.key,
    required this.recordId,
    required this.day,
  });

  @override
  ConsumerState<SelfAssessmentScreen> createState() =>
      _SelfAssessmentScreenState();
}

class _SelfAssessmentScreenState extends ConsumerState<SelfAssessmentScreen> {
  final _commentsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssessment();
    });
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  void _loadAssessment() {
    final params = SelfAssessmentFormParams(
      recordId: widget.recordId,
      day: widget.day,
    );
    ref.read(selfAssessmentFormProvider(params).notifier).loadExistingAssessment();
  }

  SelfAssessmentFormParams get _params => SelfAssessmentFormParams(
        recordId: widget.recordId,
        day: widget.day,
      );

  Future<void> _saveDraft() async {
    final notifier = ref.read(selfAssessmentFormProvider(_params).notifier);
    notifier.updateComments(_commentsController.text);

    final success = await notifier.saveDraft();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกแบบร่างสำเร็จ'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _submitAssessment() async {
    final notifier = ref.read(selfAssessmentFormProvider(_params).notifier);
    notifier.updateComments(_commentsController.text);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการส่ง'),
        content: const Text(
          'เมื่อส่งการประเมินแล้วจะไม่สามารถแก้ไขได้ ต้องการดำเนินการหรือไม่?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await notifier.submitAssessment();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งการประเมินตนเองสำเร็จ'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selfAssessmentFormProvider(_params));

    // Show error snackbar
    ref.listen(selfAssessmentFormProvider(_params), (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(selfAssessmentFormProvider(_params).notifier).clearError();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: 'ประเมินตนเอง Day ${widget.day}',
        showBackButton: true,
        actions: [
          if (!state.isLoading)
            TextButton(
              onPressed: state.isSubmitting ? null : _saveDraft,
              child: const Text(
                'บันทึกร่าง',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _buildBody(state),
      bottomNavigationBar: state.isLoading
          ? null
          : _buildBottomBar(state),
    );
  }

  Widget _buildBody(SelfAssessmentFormState state) {
    if (state.isLoading) {
      return const LoadingWidget(message: 'กำลังโหลดข้อมูล...');
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions card
            Card(
              color: AppColors.primary.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'คำแนะนำ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'กรุณาประเมินตนเองตามความเป็นจริง โดยให้คะแนน 1-5 ในแต่ละหัวข้อ\n'
                            '• คะแนน 3 ขึ้นไป = ผ่านเกณฑ์\n'
                            '• ต้องกรอกให้ครบทุกหัวข้อจึงจะส่งได้',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Assessment categories
            const Text(
              'หัวข้อการประเมิน',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            // Core Value
            AssessmentCategoryCard(
              title: 'Core Value',
              description: 'ความคิดสร้างสรรค์และความรวดเร็ว (Lottery Plus Style)',
              icon: Icons.lightbulb,
              iconColor: Colors.amber,
              score: state.coreValue?.score,
              comment: state.coreValue?.comment,
              onScoreChanged: (score) {
                ref
                    .read(selfAssessmentFormProvider(_params).notifier)
                    .updateCoreValue(score, comment: state.coreValue?.comment);
              },
              onCommentChanged: (comment) {
                ref
                    .read(selfAssessmentFormProvider(_params).notifier)
                    .updateCoreValue(
                      state.coreValue?.score ?? 0,
                      comment: comment,
                    );
              },
              enabled: !state.isSubmitting,
            ),

            // Job Performance
            AssessmentCategoryCard(
              title: 'Job Performance',
              description: 'ผลงานตามรายละเอียดงาน (JD)',
              icon: Icons.work,
              iconColor: Colors.blue,
              score: state.jobPerformance?.score,
              comment: state.jobPerformance?.comment,
              onScoreChanged: (score) {
                ref
                    .read(selfAssessmentFormProvider(_params).notifier)
                    .updateJobPerformance(
                      score,
                      comment: state.jobPerformance?.comment,
                    );
              },
              onCommentChanged: (comment) {
                ref
                    .read(selfAssessmentFormProvider(_params).notifier)
                    .updateJobPerformance(
                      state.jobPerformance?.score ?? 0,
                      comment: comment,
                    );
              },
              enabled: !state.isSubmitting,
            ),

            // Attendance
            AssessmentCategoryCard(
              title: 'Attendance',
              description: 'การมาทำงานตรงต่อเวลา',
              icon: Icons.access_time,
              iconColor: Colors.green,
              score: state.attendance?.score,
              comment: state.attendance?.comment,
              onScoreChanged: (score) {
                ref
                    .read(selfAssessmentFormProvider(_params).notifier)
                    .updateAttendance(score, comment: state.attendance?.comment);
              },
              onCommentChanged: (comment) {
                ref
                    .read(selfAssessmentFormProvider(_params).notifier)
                    .updateAttendance(
                      state.attendance?.score ?? 0,
                      comment: comment,
                    );
              },
              enabled: !state.isSubmitting,
            ),

            // Culture Fit
            AssessmentCategoryCard(
              title: 'Culture Fit',
              description: 'การปรับตัวเข้ากับทีมและ CI ขององค์กร',
              icon: Icons.people,
              iconColor: Colors.purple,
              score: state.cultureFit?.score,
              comment: state.cultureFit?.comment,
              onScoreChanged: (score) {
                ref
                    .read(selfAssessmentFormProvider(_params).notifier)
                    .updateCultureFit(score, comment: state.cultureFit?.comment);
              },
              onCommentChanged: (comment) {
                ref
                    .read(selfAssessmentFormProvider(_params).notifier)
                    .updateCultureFit(
                      state.cultureFit?.score ?? 0,
                      comment: comment,
                    );
              },
              enabled: !state.isSubmitting,
            ),

            const SizedBox(height: 16),

            // Overall comments
            const Text(
              'ความคิดเห็นเพิ่มเติม',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentsController,
              decoration: const InputDecoration(
                hintText: 'กรอกความคิดเห็นหรือข้อเสนอแนะ (ไม่บังคับ)...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              enabled: !state.isSubmitting,
            ),

            // Average score display
            if (state.isValid) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'คะแนนเฉลี่ย',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'จากการประเมินทั้ง 4 หัวข้อ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ScoreBadge(score: state.averageScore!),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(SelfAssessmentFormState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!state.isValid)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.orange.shade700,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'กรุณากรอกคะแนนให้ครบทุกหัวข้อก่อนส่ง',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isValid && !state.isSubmitting
                    ? _submitAssessment
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: state.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'ส่งการประเมิน',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
