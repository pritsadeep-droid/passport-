import 'package:dio/dio.dart';
import 'api_client.dart';

class MilestoneSettingsData {
  final int defaultProbationDays;
  final List<int> probationDayOptions;
  final Map<String, List<int>> milestoneDays;

  MilestoneSettingsData({
    required this.defaultProbationDays,
    required this.probationDayOptions,
    required this.milestoneDays,
  });

  factory MilestoneSettingsData.fromJson(Map<String, dynamic> json) {
    final rawMilestones = json['milestoneDays'] as Map<String, dynamic>? ?? {};
    final milestoneDays = rawMilestones.map(
      (key, value) => MapEntry(
        key,
        (value as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      ),
    );

    return MilestoneSettingsData(
      defaultProbationDays: (json['defaultProbationDays'] as num?)?.toInt() ?? 90,
      probationDayOptions: (json['probationDayOptions'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [90, 119],
      milestoneDays: milestoneDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultProbationDays': defaultProbationDays,
      'probationDayOptions': probationDayOptions,
      'milestoneDays': milestoneDays.map(
        (key, value) => MapEntry(key, value),
      ),
    };
  }

  MilestoneSettingsData copyWith({
    int? defaultProbationDays,
    List<int>? probationDayOptions,
    Map<String, List<int>>? milestoneDays,
  }) {
    return MilestoneSettingsData(
      defaultProbationDays: defaultProbationDays ?? this.defaultProbationDays,
      probationDayOptions: probationDayOptions ?? this.probationDayOptions,
      milestoneDays: milestoneDays ?? this.milestoneDays,
    );
  }
}

class SettingsService {
  final ApiClient _apiClient;

  SettingsService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<MilestoneSettingsData> getSettings() async {
    try {
      final response = await _apiClient.get('/settings');
      return MilestoneSettingsData.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<MilestoneSettingsData> updateMilestoneSettings(
    MilestoneSettingsData data,
  ) async {
    try {
      final response = await _apiClient.put(
        '/settings/milestones',
        data: data.toJson(),
      );
      return MilestoneSettingsData.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
