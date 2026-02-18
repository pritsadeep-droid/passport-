import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/assessment.dart';

class LocalStorage {
  static const _draftBoxName = 'assessment_drafts';
  static const _settingsBoxName = 'settings';

  late Box<String> _draftBox;
  late Box<dynamic> _settingsBox;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();

    _draftBox = await Hive.openBox<String>(_draftBoxName);
    _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);
  }

  /// Close all boxes
  Future<void> close() async {
    await _draftBox.close();
    await _settingsBox.close();
  }

  /// Clear all local data
  Future<void> clearAll() async {
    await _draftBox.clear();
    await _settingsBox.clear();
  }

  // ============ Assessment Draft Methods ============

  /// Generate draft key
  String _getDraftKey(String probationRecordId, int milestoneDay) {
    return '${probationRecordId}_$milestoneDay';
  }

  /// Save assessment draft
  Future<void> saveDraft(AssessmentDraft draft) async {
    final key = _getDraftKey(draft.probationRecordId, draft.milestoneDay);
    final json = jsonEncode(draft.toJson());
    await _draftBox.put(key, json);
  }

  /// Get assessment draft
  AssessmentDraft? getDraft(String probationRecordId, int milestoneDay) {
    final key = _getDraftKey(probationRecordId, milestoneDay);
    final json = _draftBox.get(key);
    if (json == null) return null;

    try {
      return AssessmentDraft.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  /// Delete assessment draft
  Future<void> deleteDraft(String probationRecordId, int milestoneDay) async {
    final key = _getDraftKey(probationRecordId, milestoneDay);
    await _draftBox.delete(key);
  }

  /// Check if draft exists
  bool hasDraft(String probationRecordId, int milestoneDay) {
    final key = _getDraftKey(probationRecordId, milestoneDay);
    return _draftBox.containsKey(key);
  }

  /// Get all drafts for a probation record
  List<AssessmentDraft> getDraftsForRecord(String probationRecordId) {
    final drafts = <AssessmentDraft>[];
    for (final key in _draftBox.keys) {
      if (key.toString().startsWith(probationRecordId)) {
        final json = _draftBox.get(key);
        if (json != null) {
          try {
            drafts.add(AssessmentDraft.fromJson(jsonDecode(json)));
          } catch (e) {
            // Skip invalid drafts
          }
        }
      }
    }
    return drafts;
  }

  /// Clear all drafts for a probation record
  Future<void> clearDraftsForRecord(String probationRecordId) async {
    final keysToDelete = <String>[];
    for (final key in _draftBox.keys) {
      if (key.toString().startsWith(probationRecordId)) {
        keysToDelete.add(key.toString());
      }
    }
    await _draftBox.deleteAll(keysToDelete);
  }

  // ============ Settings Methods ============

  /// Save setting
  Future<void> setSetting<T>(String key, T value) async {
    await _settingsBox.put(key, value);
  }

  /// Get setting
  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  /// Delete setting
  Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  /// Check if setting exists
  bool hasSetting(String key) {
    return _settingsBox.containsKey(key);
  }

  // ============ Common Settings Keys ============

  static const keyLocale = 'locale';
  static const keyThemeMode = 'theme_mode';
  static const keyNotificationsEnabled = 'notifications_enabled';
  static const keyLastSyncTime = 'last_sync_time';

  /// Get locale preference
  String? getLocale() => getSetting<String>(keyLocale);

  /// Set locale preference
  Future<void> setLocale(String locale) => setSetting(keyLocale, locale);

  /// Get theme mode preference
  String? getThemeMode() => getSetting<String>(keyThemeMode);

  /// Set theme mode preference
  Future<void> setThemeMode(String mode) => setSetting(keyThemeMode, mode);

  /// Get notifications enabled preference
  bool getNotificationsEnabled() =>
      getSetting<bool>(keyNotificationsEnabled, defaultValue: true) ?? true;

  /// Set notifications enabled preference
  Future<void> setNotificationsEnabled(bool enabled) =>
      setSetting(keyNotificationsEnabled, enabled);

  /// Get last sync time
  DateTime? getLastSyncTime() {
    final timestamp = getSetting<int>(keyLastSyncTime);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Set last sync time
  Future<void> setLastSyncTime(DateTime time) =>
      setSetting(keyLastSyncTime, time.millisecondsSinceEpoch);
}
