// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      id: json['_id'] as String,
      text: json['text'] as String,
      type: $enumDecodeNullable(_$QuestionTypeEnumMap, json['type']) ??
          QuestionType.textLong,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      required: json['required'] as bool? ?? true,
      missionCode: json['missionCode'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'options': instance.options,
      'required': instance.required,
      'missionCode': instance.missionCode,
      'sortOrder': instance.sortOrder,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.textShort: 'text_short',
  QuestionType.textLong: 'text_long',
  QuestionType.rating: 'rating',
  QuestionType.singleChoice: 'single_choice',
  QuestionType.fileUpload: 'file_upload',
};

_$MissionImpl _$$MissionImplFromJson(Map<String, dynamic> json) =>
    _$MissionImpl(
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      openOffsetDays: (json['openOffsetDays'] as num?)?.toInt() ?? 0,
      closeOffsetDays: (json['closeOffsetDays'] as num?)?.toInt() ?? 7,
    );

Map<String, dynamic> _$$MissionImplToJson(_$MissionImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'description': instance.description,
      'openOffsetDays': instance.openOffsetDays,
      'closeOffsetDays': instance.closeOffsetDays,
    };

_$JourneyEventImpl _$$JourneyEventImplFromJson(Map<String, dynamic> json) =>
    _$JourneyEventImpl(
      code: json['code'] as String,
      title: json['title'] as String,
      titleTh: json['titleTh'] as String?,
      description: json['description'] as String?,
      type: $enumDecodeNullable(_$EventTypeEnumMap, json['type']) ??
          EventType.other,
      day: (json['day'] as num).toInt(),
      duration: json['duration'] as String?,
      isLinkedToMilestone: json['isLinkedToMilestone'] as bool? ?? false,
      milestoneDay: (json['milestoneDay'] as num?)?.toInt(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$JourneyEventImplToJson(_$JourneyEventImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'titleTh': instance.titleTh,
      'description': instance.description,
      'type': _$EventTypeEnumMap[instance.type]!,
      'day': instance.day,
      'duration': instance.duration,
      'isLinkedToMilestone': instance.isLinkedToMilestone,
      'milestoneDay': instance.milestoneDay,
      'sortOrder': instance.sortOrder,
    };

const _$EventTypeEnumMap = {
  EventType.orientation: 'orientation',
  EventType.workshop: 'workshop',
  EventType.training: 'training',
  EventType.evaluation: 'evaluation',
  EventType.feedback: 'feedback',
  EventType.celebration: 'celebration',
  EventType.other: 'other',
};

_$EventCompletionImpl _$$EventCompletionImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCompletionImpl(
      id: json['_id'] as String?,
      eventCode: json['eventCode'] as String,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      completedBy: json['completedBy'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$EventCompletionImplToJson(
        _$EventCompletionImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'eventCode': instance.eventCode,
      'completedAt': instance.completedAt?.toIso8601String(),
      'completedBy': instance.completedBy,
      'notes': instance.notes,
    };

_$OnboardingTemplateImpl _$$OnboardingTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingTemplateImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      missions: (json['missions'] as List<dynamic>?)
              ?.map((e) => Mission.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => JourneyEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 119,
      isActive: json['isActive'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OnboardingTemplateImplToJson(
        _$OnboardingTemplateImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'missions': instance.missions,
      'questions': instance.questions,
      'events': instance.events,
      'durationDays': instance.durationDays,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$AnswerImpl _$$AnswerImplFromJson(Map<String, dynamic> json) => _$AnswerImpl(
      id: json['_id'] as String?,
      questionId: json['questionId'] as String,
      text: json['text'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
    );

Map<String, dynamic> _$$AnswerImplToJson(_$AnswerImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'questionId': instance.questionId,
      'text': instance.text,
      'attachments': instance.attachments,
      'submittedAt': instance.submittedAt?.toIso8601String(),
    };

_$ReviewerInfoImpl _$$ReviewerInfoImplFromJson(Map<String, dynamic> json) =>
    _$ReviewerInfoImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ReviewerInfoImplToJson(_$ReviewerInfoImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      id: json['_id'] as String?,
      missionCode: json['missionCode'] as String,
      decision: json['decision'] as String,
      score: (json['score'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
      reviewedBy: json['reviewedBy'] == null
          ? null
          : ReviewerInfo.fromJson(json['reviewedBy'] as Map<String, dynamic>),
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'missionCode': instance.missionCode,
      'decision': instance.decision,
      'score': instance.score,
      'comment': instance.comment,
      'reviewedBy': instance.reviewedBy,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
    };

_$OnboardingInstanceImpl _$$OnboardingInstanceImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingInstanceImpl(
      id: json['_id'] as String,
      employeeId: json['employeeId'] as String,
      templateId: OnboardingTemplate.fromJson(
          json['templateId'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      status: json['status'] as String,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      eventCompletions: (json['eventCompletions'] as List<dynamic>?)
              ?.map((e) => EventCompletion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OnboardingInstanceImplToJson(
        _$OnboardingInstanceImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'employeeId': instance.employeeId,
      'templateId': instance.templateId,
      'startDate': instance.startDate.toIso8601String(),
      'status': instance.status,
      'answers': instance.answers,
      'reviews': instance.reviews,
      'eventCompletions': instance.eventCompletions,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$AssignOnboardingRequestImpl _$$AssignOnboardingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AssignOnboardingRequestImpl(
      employeeId: json['employeeId'] as String,
      templateId: json['templateId'] as String,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
    );

Map<String, dynamic> _$$AssignOnboardingRequestImplToJson(
        _$AssignOnboardingRequestImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'templateId': instance.templateId,
      'startDate': instance.startDate?.toIso8601String(),
    };

_$SubmitAnswerRequestImpl _$$SubmitAnswerRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SubmitAnswerRequestImpl(
      questionId: json['questionId'] as String,
      text: json['text'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SubmitAnswerRequestImplToJson(
        _$SubmitAnswerRequestImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'text': instance.text,
      'attachments': instance.attachments,
    };

_$ReviewMissionRequestImpl _$$ReviewMissionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewMissionRequestImpl(
      onboardingId: json['onboardingId'] as String,
      missionCode: json['missionCode'] as String,
      decision: json['decision'] as String,
      score: (json['score'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$ReviewMissionRequestImplToJson(
        _$ReviewMissionRequestImpl instance) =>
    <String, dynamic>{
      'onboardingId': instance.onboardingId,
      'missionCode': instance.missionCode,
      'decision': instance.decision,
      'score': instance.score,
      'comment': instance.comment,
    };
