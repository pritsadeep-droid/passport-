import 'package:flutter/material.dart';
import '../models/probation_record.dart';
import '../utils/theme.dart';

/// Widget to display assessment summary
class AssessmentSummary extends StatelessWidget {
  final SelfAssessment? selfAssessment;
  final SupervisorAssessment? supervisorAssessment;
  final bool showDetails;

  const AssessmentSummary({
    super.key,
    this.selfAssessment,
    this.supervisorAssessment,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    if (selfAssessment == null && supervisorAssessment == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'ยังไม่มีข้อมูลการประเมิน',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selfAssessment != null) ...[
          _AssessmentCard(
            title: 'การประเมินตนเอง',
            icon: Icons.person,
            iconColor: AppColors.primary,
            assessment: selfAssessment!,
            showDetails: showDetails,
          ),
          if (supervisorAssessment != null) const SizedBox(height: 16),
        ],
        if (supervisorAssessment != null)
          _SupervisorAssessmentCard(
            assessment: supervisorAssessment!,
            showDetails: showDetails,
          ),
      ],
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final SelfAssessment assessment;
  final bool showDetails;

  const _AssessmentCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.assessment,
    required this.showDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isPassing = (assessment.averageScore ?? 0) >= 3.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (assessment.averageScore != null)
                  _ScoreChip(
                    score: assessment.averageScore!,
                    isPassing: isPassing,
                  ),
              ],
            ),
            if (showDetails) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              _ScoreRow(label: 'Core Value', score: assessment.coreValue),
              _ScoreRow(label: 'Job Performance', score: assessment.jobPerformance),
              _ScoreRow(label: 'Attendance', score: assessment.attendance),
              _ScoreRow(label: 'Culture Fit', score: assessment.cultureFit),
              if (assessment.comments != null &&
                  assessment.comments!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'ความคิดเห็น:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    assessment.comments!,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ],
            if (assessment.isDraft == true) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'แบบร่าง',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SupervisorAssessmentCard extends StatelessWidget {
  final SupervisorAssessment assessment;
  final bool showDetails;

  const _SupervisorAssessmentCard({
    required this.assessment,
    required this.showDetails,
  });

  String _getRecommendationText(String? recommendation) {
    switch (recommendation) {
      case 'pass':
        return 'ผ่าน';
      case 'fail':
        return 'ไม่ผ่าน';
      case 'extend':
        return 'ขยายเวลา';
      default:
        return '-';
    }
  }

  Color _getRecommendationColor(String? recommendation) {
    switch (recommendation) {
      case 'pass':
        return Colors.green;
      case 'fail':
        return Colors.red;
      case 'extend':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPassing = (assessment.averageScore ?? 0) >= 3.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.supervisor_account, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'การประเมินโดยหัวหน้า',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (assessment.averageScore != null)
                  _ScoreChip(
                    score: assessment.averageScore!,
                    isPassing: isPassing,
                  ),
              ],
            ),
            if (showDetails) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              _ScoreRow(label: 'Core Value', score: assessment.coreValue),
              _ScoreRow(label: 'Job Performance', score: assessment.jobPerformance),
              _ScoreRow(label: 'Attendance', score: assessment.attendance),
              _ScoreRow(label: 'Culture Fit', score: assessment.cultureFit),
              if (assessment.kpiScores != null &&
                  assessment.kpiScores!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'คะแนน KPI:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                ...assessment.kpiScores!.map((kpi) => _ScoreRow(
                      label: 'KPI',
                      score: kpi.score != null
                          ? AssessmentScoreData(score: kpi.score, comment: kpi.comment)
                          : null,
                    )),
              ],
              if (assessment.recommendation != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'ข้อเสนอแนะ: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRecommendationColor(assessment.recommendation)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getRecommendationText(assessment.recommendation),
                        style: TextStyle(
                          color: _getRecommendationColor(assessment.recommendation),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (assessment.overallComment != null &&
                  assessment.overallComment!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'ความคิดเห็นโดยรวม:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    assessment.overallComment!,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final AssessmentScoreData? score;

  const _ScoreRow({
    required this.label,
    this.score,
  });

  String _getScoreLabel(int score) {
    switch (score) {
      case 1:
        return 'ต้องปรับปรุงมาก';
      case 2:
        return 'ต้องปรับปรุง';
      case 3:
        return 'พอใช้';
      case 4:
        return 'ดี';
      case 5:
        return 'ดีเยี่ยม';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
          if (score?.score != null) ...[
            SizedBox(
              width: 100,
              child: Row(
                children: List.generate(5, (index) {
                  final isFilled = index < (score?.score ?? 0);
                  return Icon(
                    isFilled ? Icons.star : Icons.star_border,
                    size: 16,
                    color: isFilled ? Colors.amber : Colors.grey.shade300,
                  );
                }),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: Text(
                _getScoreLabel(score!.score!),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ] else
            Text(
              '-',
              style: TextStyle(color: Colors.grey.shade400),
            ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final double score;
  final bool isPassing;

  const _ScoreChip({
    required this.score,
    required this.isPassing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPassing ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPassing ? Icons.check_circle : Icons.warning,
            size: 16,
            color: isPassing ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            score.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPassing ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact assessment comparison widget
class AssessmentComparison extends StatelessWidget {
  final SelfAssessment? selfAssessment;
  final SupervisorAssessment? supervisorAssessment;

  const AssessmentComparison({
    super.key,
    this.selfAssessment,
    this.supervisorAssessment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'เปรียบเทียบคะแนน',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _ComparisonRow(
              label: 'Core Value',
              selfScore: selfAssessment?.coreValue?.score,
              supervisorScore: supervisorAssessment?.coreValue?.score,
            ),
            _ComparisonRow(
              label: 'Job Performance',
              selfScore: selfAssessment?.jobPerformance?.score,
              supervisorScore: supervisorAssessment?.jobPerformance?.score,
            ),
            _ComparisonRow(
              label: 'Attendance',
              selfScore: selfAssessment?.attendance?.score,
              supervisorScore: supervisorAssessment?.attendance?.score,
            ),
            _ComparisonRow(
              label: 'Culture Fit',
              selfScore: selfAssessment?.cultureFit?.score,
              supervisorScore: supervisorAssessment?.cultureFit?.score,
            ),
            const Divider(),
            _ComparisonRow(
              label: 'คะแนนเฉลี่ย',
              selfScore: selfAssessment?.averageScore?.toInt(),
              supervisorScore: supervisorAssessment?.averageScore?.toInt(),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final int? selfScore;
  final int? supervisorScore;
  final bool isBold;

  const _ComparisonRow({
    required this.label,
    this.selfScore,
    this.supervisorScore,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                selfScore?.toString() ?? '-',
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                supervisorScore?.toString() ?? '-',
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
