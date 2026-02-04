// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  QuestionType get type => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  String get missionCode => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res, Question>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String text,
      QuestionType type,
      List<String> options,
      bool required,
      String missionCode,
      int sortOrder});
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res, $Val extends Question>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? options = null,
    Object? required = null,
    Object? missionCode = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      missionCode: null == missionCode
          ? _value.missionCode
          : missionCode // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionImplCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$$QuestionImplCopyWith(
          _$QuestionImpl value, $Res Function(_$QuestionImpl) then) =
      __$$QuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String text,
      QuestionType type,
      List<String> options,
      bool required,
      String missionCode,
      int sortOrder});
}

/// @nodoc
class __$$QuestionImplCopyWithImpl<$Res>
    extends _$QuestionCopyWithImpl<$Res, _$QuestionImpl>
    implements _$$QuestionImplCopyWith<$Res> {
  __$$QuestionImplCopyWithImpl(
      _$QuestionImpl _value, $Res Function(_$QuestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? options = null,
    Object? required = null,
    Object? missionCode = null,
    Object? sortOrder = null,
  }) {
    return _then(_$QuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      missionCode: null == missionCode
          ? _value.missionCode
          : missionCode // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionImpl implements _Question {
  const _$QuestionImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.text,
      this.type = QuestionType.textLong,
      final List<String> options = const [],
      this.required = true,
      required this.missionCode,
      this.sortOrder = 0})
      : _options = options;

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String text;
  @override
  @JsonKey()
  final QuestionType type;
  final List<String> _options;
  @override
  @JsonKey()
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  @JsonKey()
  final bool required;
  @override
  final String missionCode;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'Question(id: $id, text: $text, type: $type, options: $options, required: $required, missionCode: $missionCode, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.missionCode, missionCode) ||
                other.missionCode == missionCode) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      type,
      const DeepCollectionEquality().hash(_options),
      required,
      missionCode,
      sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      __$$QuestionImplCopyWithImpl<_$QuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionImplToJson(
      this,
    );
  }
}

abstract class _Question implements Question {
  const factory _Question(
      {@JsonKey(name: '_id') required final String id,
      required final String text,
      final QuestionType type,
      final List<String> options,
      final bool required,
      required final String missionCode,
      final int sortOrder}) = _$QuestionImpl;

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get text;
  @override
  QuestionType get type;
  @override
  List<String> get options;
  @override
  bool get required;
  @override
  String get missionCode;
  @override
  int get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Mission _$MissionFromJson(Map<String, dynamic> json) {
  return _Mission.fromJson(json);
}

/// @nodoc
mixin _$Mission {
  String get code => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get openOffsetDays => throw _privateConstructorUsedError;
  int get closeOffsetDays => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false)
  MissionStatus? get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionCopyWith<Mission> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionCopyWith<$Res> {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) then) =
      _$MissionCopyWithImpl<$Res, Mission>;
  @useResult
  $Res call(
      {String code,
      String title,
      String? description,
      int openOffsetDays,
      int closeOffsetDays,
      @JsonKey(includeFromJson: false) MissionStatus? status});
}

/// @nodoc
class _$MissionCopyWithImpl<$Res, $Val extends Mission>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? title = null,
    Object? description = freezed,
    Object? openOffsetDays = null,
    Object? closeOffsetDays = null,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      openOffsetDays: null == openOffsetDays
          ? _value.openOffsetDays
          : openOffsetDays // ignore: cast_nullable_to_non_nullable
              as int,
      closeOffsetDays: null == closeOffsetDays
          ? _value.closeOffsetDays
          : closeOffsetDays // ignore: cast_nullable_to_non_nullable
              as int,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MissionStatus?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionImplCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$$MissionImplCopyWith(
          _$MissionImpl value, $Res Function(_$MissionImpl) then) =
      __$$MissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String title,
      String? description,
      int openOffsetDays,
      int closeOffsetDays,
      @JsonKey(includeFromJson: false) MissionStatus? status});
}

/// @nodoc
class __$$MissionImplCopyWithImpl<$Res>
    extends _$MissionCopyWithImpl<$Res, _$MissionImpl>
    implements _$$MissionImplCopyWith<$Res> {
  __$$MissionImplCopyWithImpl(
      _$MissionImpl _value, $Res Function(_$MissionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? title = null,
    Object? description = freezed,
    Object? openOffsetDays = null,
    Object? closeOffsetDays = null,
    Object? status = freezed,
  }) {
    return _then(_$MissionImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      openOffsetDays: null == openOffsetDays
          ? _value.openOffsetDays
          : openOffsetDays // ignore: cast_nullable_to_non_nullable
              as int,
      closeOffsetDays: null == closeOffsetDays
          ? _value.closeOffsetDays
          : closeOffsetDays // ignore: cast_nullable_to_non_nullable
              as int,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MissionStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionImpl implements _Mission {
  const _$MissionImpl(
      {required this.code,
      required this.title,
      this.description,
      this.openOffsetDays = 0,
      this.closeOffsetDays = 7,
      @JsonKey(includeFromJson: false) this.status});

  factory _$MissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionImplFromJson(json);

  @override
  final String code;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final int openOffsetDays;
  @override
  @JsonKey()
  final int closeOffsetDays;
  @override
  @JsonKey(includeFromJson: false)
  final MissionStatus? status;

  @override
  String toString() {
    return 'Mission(code: $code, title: $title, description: $description, openOffsetDays: $openOffsetDays, closeOffsetDays: $closeOffsetDays, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.openOffsetDays, openOffsetDays) ||
                other.openOffsetDays == openOffsetDays) &&
            (identical(other.closeOffsetDays, closeOffsetDays) ||
                other.closeOffsetDays == closeOffsetDays) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, title, description,
      openOffsetDays, closeOffsetDays, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      __$$MissionImplCopyWithImpl<_$MissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionImplToJson(
      this,
    );
  }
}

abstract class _Mission implements Mission {
  const factory _Mission(
          {required final String code,
          required final String title,
          final String? description,
          final int openOffsetDays,
          final int closeOffsetDays,
          @JsonKey(includeFromJson: false) final MissionStatus? status}) =
      _$MissionImpl;

  factory _Mission.fromJson(Map<String, dynamic> json) = _$MissionImpl.fromJson;

  @override
  String get code;
  @override
  String get title;
  @override
  String? get description;
  @override
  int get openOffsetDays;
  @override
  int get closeOffsetDays;
  @override
  @JsonKey(includeFromJson: false)
  MissionStatus? get status;
  @override
  @JsonKey(ignore: true)
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OnboardingTemplate _$OnboardingTemplateFromJson(Map<String, dynamic> json) {
  return _OnboardingTemplate.fromJson(json);
}

/// @nodoc
mixin _$OnboardingTemplate {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<Mission> get missions => throw _privateConstructorUsedError;
  List<Question> get questions => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OnboardingTemplateCopyWith<OnboardingTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingTemplateCopyWith<$Res> {
  factory $OnboardingTemplateCopyWith(
          OnboardingTemplate value, $Res Function(OnboardingTemplate) then) =
      _$OnboardingTemplateCopyWithImpl<$Res, OnboardingTemplate>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      String? description,
      List<Mission> missions,
      List<Question> questions,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$OnboardingTemplateCopyWithImpl<$Res, $Val extends OnboardingTemplate>
    implements $OnboardingTemplateCopyWith<$Res> {
  _$OnboardingTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? missions = null,
    Object? questions = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      missions: null == missions
          ? _value.missions
          : missions // ignore: cast_nullable_to_non_nullable
              as List<Mission>,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingTemplateImplCopyWith<$Res>
    implements $OnboardingTemplateCopyWith<$Res> {
  factory _$$OnboardingTemplateImplCopyWith(_$OnboardingTemplateImpl value,
          $Res Function(_$OnboardingTemplateImpl) then) =
      __$$OnboardingTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      String? description,
      List<Mission> missions,
      List<Question> questions,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$OnboardingTemplateImplCopyWithImpl<$Res>
    extends _$OnboardingTemplateCopyWithImpl<$Res, _$OnboardingTemplateImpl>
    implements _$$OnboardingTemplateImplCopyWith<$Res> {
  __$$OnboardingTemplateImplCopyWithImpl(_$OnboardingTemplateImpl _value,
      $Res Function(_$OnboardingTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? missions = null,
    Object? questions = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OnboardingTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      missions: null == missions
          ? _value._missions
          : missions // ignore: cast_nullable_to_non_nullable
              as List<Mission>,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingTemplateImpl implements _OnboardingTemplate {
  const _$OnboardingTemplateImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.name,
      this.description,
      final List<Mission> missions = const [],
      final List<Question> questions = const [],
      this.createdAt,
      this.updatedAt})
      : _missions = missions,
        _questions = questions;

  factory _$OnboardingTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingTemplateImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String? description;
  final List<Mission> _missions;
  @override
  @JsonKey()
  List<Mission> get missions {
    if (_missions is EqualUnmodifiableListView) return _missions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missions);
  }

  final List<Question> _questions;
  @override
  @JsonKey()
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'OnboardingTemplate(id: $id, name: $name, description: $description, missions: $missions, questions: $questions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._missions, _missions) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_missions),
      const DeepCollectionEquality().hash(_questions),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingTemplateImplCopyWith<_$OnboardingTemplateImpl> get copyWith =>
      __$$OnboardingTemplateImplCopyWithImpl<_$OnboardingTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingTemplateImplToJson(
      this,
    );
  }
}

abstract class _OnboardingTemplate implements OnboardingTemplate {
  const factory _OnboardingTemplate(
      {@JsonKey(name: '_id') required final String id,
      required final String name,
      final String? description,
      final List<Mission> missions,
      final List<Question> questions,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$OnboardingTemplateImpl;

  factory _OnboardingTemplate.fromJson(Map<String, dynamic> json) =
      _$OnboardingTemplateImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<Mission> get missions;
  @override
  List<Question> get questions;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingTemplateImplCopyWith<_$OnboardingTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  return _Answer.fromJson(json);
}

/// @nodoc
mixin _$Answer {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get questionId => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnswerCopyWith<Answer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerCopyWith<$Res> {
  factory $AnswerCopyWith(Answer value, $Res Function(Answer) then) =
      _$AnswerCopyWithImpl<$Res, Answer>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String questionId,
      String? text,
      List<String> attachments,
      DateTime? submittedAt});
}

/// @nodoc
class _$AnswerCopyWithImpl<$Res, $Val extends Answer>
    implements $AnswerCopyWith<$Res> {
  _$AnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? questionId = null,
    Object? text = freezed,
    Object? attachments = null,
    Object? submittedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnswerImplCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory _$$AnswerImplCopyWith(
          _$AnswerImpl value, $Res Function(_$AnswerImpl) then) =
      __$$AnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String questionId,
      String? text,
      List<String> attachments,
      DateTime? submittedAt});
}

/// @nodoc
class __$$AnswerImplCopyWithImpl<$Res>
    extends _$AnswerCopyWithImpl<$Res, _$AnswerImpl>
    implements _$$AnswerImplCopyWith<$Res> {
  __$$AnswerImplCopyWithImpl(
      _$AnswerImpl _value, $Res Function(_$AnswerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? questionId = null,
    Object? text = freezed,
    Object? attachments = null,
    Object? submittedAt = freezed,
  }) {
    return _then(_$AnswerImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerImpl implements _Answer {
  const _$AnswerImpl(
      {@JsonKey(name: '_id') this.id,
      required this.questionId,
      this.text,
      final List<String> attachments = const [],
      this.submittedAt})
      : _attachments = attachments;

  factory _$AnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String questionId;
  @override
  final String? text;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final DateTime? submittedAt;

  @override
  String toString() {
    return 'Answer(id: $id, questionId: $questionId, text: $text, attachments: $attachments, submittedAt: $submittedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, questionId, text,
      const DeepCollectionEquality().hash(_attachments), submittedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerImplCopyWith<_$AnswerImpl> get copyWith =>
      __$$AnswerImplCopyWithImpl<_$AnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerImplToJson(
      this,
    );
  }
}

abstract class _Answer implements Answer {
  const factory _Answer(
      {@JsonKey(name: '_id') final String? id,
      required final String questionId,
      final String? text,
      final List<String> attachments,
      final DateTime? submittedAt}) = _$AnswerImpl;

  factory _Answer.fromJson(Map<String, dynamic> json) = _$AnswerImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get questionId;
  @override
  String? get text;
  @override
  List<String> get attachments;
  @override
  DateTime? get submittedAt;
  @override
  @JsonKey(ignore: true)
  _$$AnswerImplCopyWith<_$AnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get missionCode => throw _privateConstructorUsedError;
  String get decision => throw _privateConstructorUsedError;
  double? get score => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  String? get reviewedBy =>
      throw _privateConstructorUsedError; // ID or Name if populated
  DateTime? get reviewedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String missionCode,
      String decision,
      double? score,
      String? comment,
      String? reviewedBy,
      DateTime? reviewedAt});
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? missionCode = null,
    Object? decision = null,
    Object? score = freezed,
    Object? comment = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      missionCode: null == missionCode
          ? _value.missionCode
          : missionCode // ignore: cast_nullable_to_non_nullable
              as String,
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
          _$ReviewImpl value, $Res Function(_$ReviewImpl) then) =
      __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String missionCode,
      String decision,
      double? score,
      String? comment,
      String? reviewedBy,
      DateTime? reviewedAt});
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
      _$ReviewImpl _value, $Res Function(_$ReviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? missionCode = null,
    Object? decision = null,
    Object? score = freezed,
    Object? comment = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
  }) {
    return _then(_$ReviewImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      missionCode: null == missionCode
          ? _value.missionCode
          : missionCode // ignore: cast_nullable_to_non_nullable
              as String,
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl(
      {@JsonKey(name: '_id') this.id,
      required this.missionCode,
      required this.decision,
      this.score,
      this.comment,
      this.reviewedBy,
      this.reviewedAt});

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String missionCode;
  @override
  final String decision;
  @override
  final double? score;
  @override
  final String? comment;
  @override
  final String? reviewedBy;
// ID or Name if populated
  @override
  final DateTime? reviewedAt;

  @override
  String toString() {
    return 'Review(id: $id, missionCode: $missionCode, decision: $decision, score: $score, comment: $comment, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.missionCode, missionCode) ||
                other.missionCode == missionCode) &&
            (identical(other.decision, decision) ||
                other.decision == decision) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, missionCode, decision, score,
      comment, reviewedBy, reviewedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(
      this,
    );
  }
}

abstract class _Review implements Review {
  const factory _Review(
      {@JsonKey(name: '_id') final String? id,
      required final String missionCode,
      required final String decision,
      final double? score,
      final String? comment,
      final String? reviewedBy,
      final DateTime? reviewedAt}) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get missionCode;
  @override
  String get decision;
  @override
  double? get score;
  @override
  String? get comment;
  @override
  String? get reviewedBy;
  @override // ID or Name if populated
  DateTime? get reviewedAt;
  @override
  @JsonKey(ignore: true)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OnboardingInstance _$OnboardingInstanceFromJson(Map<String, dynamic> json) {
  return _OnboardingInstance.fromJson(json);
}

/// @nodoc
mixin _$OnboardingInstance {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  OnboardingTemplate get templateId =>
      throw _privateConstructorUsedError; // Populated
  DateTime get startDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<Answer> get answers => throw _privateConstructorUsedError;
  List<Review> get reviews => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OnboardingInstanceCopyWith<OnboardingInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingInstanceCopyWith<$Res> {
  factory $OnboardingInstanceCopyWith(
          OnboardingInstance value, $Res Function(OnboardingInstance) then) =
      _$OnboardingInstanceCopyWithImpl<$Res, OnboardingInstance>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String employeeId,
      OnboardingTemplate templateId,
      DateTime startDate,
      String status,
      List<Answer> answers,
      List<Review> reviews,
      DateTime? createdAt,
      DateTime? updatedAt});

  $OnboardingTemplateCopyWith<$Res> get templateId;
}

/// @nodoc
class _$OnboardingInstanceCopyWithImpl<$Res, $Val extends OnboardingInstance>
    implements $OnboardingInstanceCopyWith<$Res> {
  _$OnboardingInstanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? templateId = null,
    Object? startDate = null,
    Object? status = null,
    Object? answers = null,
    Object? reviews = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as OnboardingTemplate,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<Answer>,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<Review>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OnboardingTemplateCopyWith<$Res> get templateId {
    return $OnboardingTemplateCopyWith<$Res>(_value.templateId, (value) {
      return _then(_value.copyWith(templateId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnboardingInstanceImplCopyWith<$Res>
    implements $OnboardingInstanceCopyWith<$Res> {
  factory _$$OnboardingInstanceImplCopyWith(_$OnboardingInstanceImpl value,
          $Res Function(_$OnboardingInstanceImpl) then) =
      __$$OnboardingInstanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String employeeId,
      OnboardingTemplate templateId,
      DateTime startDate,
      String status,
      List<Answer> answers,
      List<Review> reviews,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $OnboardingTemplateCopyWith<$Res> get templateId;
}

/// @nodoc
class __$$OnboardingInstanceImplCopyWithImpl<$Res>
    extends _$OnboardingInstanceCopyWithImpl<$Res, _$OnboardingInstanceImpl>
    implements _$$OnboardingInstanceImplCopyWith<$Res> {
  __$$OnboardingInstanceImplCopyWithImpl(_$OnboardingInstanceImpl _value,
      $Res Function(_$OnboardingInstanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? templateId = null,
    Object? startDate = null,
    Object? status = null,
    Object? answers = null,
    Object? reviews = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OnboardingInstanceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as OnboardingTemplate,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<Answer>,
      reviews: null == reviews
          ? _value._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<Review>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingInstanceImpl implements _OnboardingInstance {
  const _$OnboardingInstanceImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.employeeId,
      required this.templateId,
      required this.startDate,
      required this.status,
      final List<Answer> answers = const [],
      final List<Review> reviews = const [],
      this.createdAt,
      this.updatedAt})
      : _answers = answers,
        _reviews = reviews;

  factory _$OnboardingInstanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingInstanceImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String employeeId;
  @override
  final OnboardingTemplate templateId;
// Populated
  @override
  final DateTime startDate;
  @override
  final String status;
  final List<Answer> _answers;
  @override
  @JsonKey()
  List<Answer> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  final List<Review> _reviews;
  @override
  @JsonKey()
  List<Review> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'OnboardingInstance(id: $id, employeeId: $employeeId, templateId: $templateId, startDate: $startDate, status: $status, answers: $answers, reviews: $reviews, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingInstanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      templateId,
      startDate,
      status,
      const DeepCollectionEquality().hash(_answers),
      const DeepCollectionEquality().hash(_reviews),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingInstanceImplCopyWith<_$OnboardingInstanceImpl> get copyWith =>
      __$$OnboardingInstanceImplCopyWithImpl<_$OnboardingInstanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingInstanceImplToJson(
      this,
    );
  }
}

abstract class _OnboardingInstance implements OnboardingInstance {
  const factory _OnboardingInstance(
      {@JsonKey(name: '_id') required final String id,
      required final String employeeId,
      required final OnboardingTemplate templateId,
      required final DateTime startDate,
      required final String status,
      final List<Answer> answers,
      final List<Review> reviews,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$OnboardingInstanceImpl;

  factory _OnboardingInstance.fromJson(Map<String, dynamic> json) =
      _$OnboardingInstanceImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get employeeId;
  @override
  OnboardingTemplate get templateId;
  @override // Populated
  DateTime get startDate;
  @override
  String get status;
  @override
  List<Answer> get answers;
  @override
  List<Review> get reviews;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingInstanceImplCopyWith<_$OnboardingInstanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssignOnboardingRequest _$AssignOnboardingRequestFromJson(
    Map<String, dynamic> json) {
  return _AssignOnboardingRequest.fromJson(json);
}

/// @nodoc
mixin _$AssignOnboardingRequest {
  String get employeeId => throw _privateConstructorUsedError;
  String get templateId => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssignOnboardingRequestCopyWith<AssignOnboardingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignOnboardingRequestCopyWith<$Res> {
  factory $AssignOnboardingRequestCopyWith(AssignOnboardingRequest value,
          $Res Function(AssignOnboardingRequest) then) =
      _$AssignOnboardingRequestCopyWithImpl<$Res, AssignOnboardingRequest>;
  @useResult
  $Res call({String employeeId, String templateId, DateTime? startDate});
}

/// @nodoc
class _$AssignOnboardingRequestCopyWithImpl<$Res,
        $Val extends AssignOnboardingRequest>
    implements $AssignOnboardingRequestCopyWith<$Res> {
  _$AssignOnboardingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? templateId = null,
    Object? startDate = freezed,
  }) {
    return _then(_value.copyWith(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssignOnboardingRequestImplCopyWith<$Res>
    implements $AssignOnboardingRequestCopyWith<$Res> {
  factory _$$AssignOnboardingRequestImplCopyWith(
          _$AssignOnboardingRequestImpl value,
          $Res Function(_$AssignOnboardingRequestImpl) then) =
      __$$AssignOnboardingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String employeeId, String templateId, DateTime? startDate});
}

/// @nodoc
class __$$AssignOnboardingRequestImplCopyWithImpl<$Res>
    extends _$AssignOnboardingRequestCopyWithImpl<$Res,
        _$AssignOnboardingRequestImpl>
    implements _$$AssignOnboardingRequestImplCopyWith<$Res> {
  __$$AssignOnboardingRequestImplCopyWithImpl(
      _$AssignOnboardingRequestImpl _value,
      $Res Function(_$AssignOnboardingRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? templateId = null,
    Object? startDate = freezed,
  }) {
    return _then(_$AssignOnboardingRequestImpl(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignOnboardingRequestImpl implements _AssignOnboardingRequest {
  const _$AssignOnboardingRequestImpl(
      {required this.employeeId, required this.templateId, this.startDate});

  factory _$AssignOnboardingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignOnboardingRequestImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String templateId;
  @override
  final DateTime? startDate;

  @override
  String toString() {
    return 'AssignOnboardingRequest(employeeId: $employeeId, templateId: $templateId, startDate: $startDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignOnboardingRequestImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, employeeId, templateId, startDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignOnboardingRequestImplCopyWith<_$AssignOnboardingRequestImpl>
      get copyWith => __$$AssignOnboardingRequestImplCopyWithImpl<
          _$AssignOnboardingRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignOnboardingRequestImplToJson(
      this,
    );
  }
}

abstract class _AssignOnboardingRequest implements AssignOnboardingRequest {
  const factory _AssignOnboardingRequest(
      {required final String employeeId,
      required final String templateId,
      final DateTime? startDate}) = _$AssignOnboardingRequestImpl;

  factory _AssignOnboardingRequest.fromJson(Map<String, dynamic> json) =
      _$AssignOnboardingRequestImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get templateId;
  @override
  DateTime? get startDate;
  @override
  @JsonKey(ignore: true)
  _$$AssignOnboardingRequestImplCopyWith<_$AssignOnboardingRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SubmitAnswerRequest _$SubmitAnswerRequestFromJson(Map<String, dynamic> json) {
  return _SubmitAnswerRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitAnswerRequest {
  String get questionId => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubmitAnswerRequestCopyWith<SubmitAnswerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitAnswerRequestCopyWith<$Res> {
  factory $SubmitAnswerRequestCopyWith(
          SubmitAnswerRequest value, $Res Function(SubmitAnswerRequest) then) =
      _$SubmitAnswerRequestCopyWithImpl<$Res, SubmitAnswerRequest>;
  @useResult
  $Res call({String questionId, String? text, List<String>? attachments});
}

/// @nodoc
class _$SubmitAnswerRequestCopyWithImpl<$Res, $Val extends SubmitAnswerRequest>
    implements $SubmitAnswerRequestCopyWith<$Res> {
  _$SubmitAnswerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? text = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_value.copyWith(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubmitAnswerRequestImplCopyWith<$Res>
    implements $SubmitAnswerRequestCopyWith<$Res> {
  factory _$$SubmitAnswerRequestImplCopyWith(_$SubmitAnswerRequestImpl value,
          $Res Function(_$SubmitAnswerRequestImpl) then) =
      __$$SubmitAnswerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String questionId, String? text, List<String>? attachments});
}

/// @nodoc
class __$$SubmitAnswerRequestImplCopyWithImpl<$Res>
    extends _$SubmitAnswerRequestCopyWithImpl<$Res, _$SubmitAnswerRequestImpl>
    implements _$$SubmitAnswerRequestImplCopyWith<$Res> {
  __$$SubmitAnswerRequestImplCopyWithImpl(_$SubmitAnswerRequestImpl _value,
      $Res Function(_$SubmitAnswerRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? text = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_$SubmitAnswerRequestImpl(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitAnswerRequestImpl implements _SubmitAnswerRequest {
  const _$SubmitAnswerRequestImpl(
      {required this.questionId, this.text, final List<String>? attachments})
      : _attachments = attachments;

  factory _$SubmitAnswerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitAnswerRequestImplFromJson(json);

  @override
  final String questionId;
  @override
  final String? text;
  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SubmitAnswerRequest(questionId: $questionId, text: $text, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitAnswerRequestImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, questionId, text,
      const DeepCollectionEquality().hash(_attachments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitAnswerRequestImplCopyWith<_$SubmitAnswerRequestImpl> get copyWith =>
      __$$SubmitAnswerRequestImplCopyWithImpl<_$SubmitAnswerRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitAnswerRequestImplToJson(
      this,
    );
  }
}

abstract class _SubmitAnswerRequest implements SubmitAnswerRequest {
  const factory _SubmitAnswerRequest(
      {required final String questionId,
      final String? text,
      final List<String>? attachments}) = _$SubmitAnswerRequestImpl;

  factory _SubmitAnswerRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitAnswerRequestImpl.fromJson;

  @override
  String get questionId;
  @override
  String? get text;
  @override
  List<String>? get attachments;
  @override
  @JsonKey(ignore: true)
  _$$SubmitAnswerRequestImplCopyWith<_$SubmitAnswerRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewMissionRequest _$ReviewMissionRequestFromJson(Map<String, dynamic> json) {
  return _ReviewMissionRequest.fromJson(json);
}

/// @nodoc
mixin _$ReviewMissionRequest {
  String get onboardingId => throw _privateConstructorUsedError;
  String get missionCode => throw _privateConstructorUsedError;
  String get decision => throw _privateConstructorUsedError;
  double? get score => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewMissionRequestCopyWith<ReviewMissionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewMissionRequestCopyWith<$Res> {
  factory $ReviewMissionRequestCopyWith(ReviewMissionRequest value,
          $Res Function(ReviewMissionRequest) then) =
      _$ReviewMissionRequestCopyWithImpl<$Res, ReviewMissionRequest>;
  @useResult
  $Res call(
      {String onboardingId,
      String missionCode,
      String decision,
      double? score,
      String? comment});
}

/// @nodoc
class _$ReviewMissionRequestCopyWithImpl<$Res,
        $Val extends ReviewMissionRequest>
    implements $ReviewMissionRequestCopyWith<$Res> {
  _$ReviewMissionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onboardingId = null,
    Object? missionCode = null,
    Object? decision = null,
    Object? score = freezed,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      onboardingId: null == onboardingId
          ? _value.onboardingId
          : onboardingId // ignore: cast_nullable_to_non_nullable
              as String,
      missionCode: null == missionCode
          ? _value.missionCode
          : missionCode // ignore: cast_nullable_to_non_nullable
              as String,
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewMissionRequestImplCopyWith<$Res>
    implements $ReviewMissionRequestCopyWith<$Res> {
  factory _$$ReviewMissionRequestImplCopyWith(_$ReviewMissionRequestImpl value,
          $Res Function(_$ReviewMissionRequestImpl) then) =
      __$$ReviewMissionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String onboardingId,
      String missionCode,
      String decision,
      double? score,
      String? comment});
}

/// @nodoc
class __$$ReviewMissionRequestImplCopyWithImpl<$Res>
    extends _$ReviewMissionRequestCopyWithImpl<$Res, _$ReviewMissionRequestImpl>
    implements _$$ReviewMissionRequestImplCopyWith<$Res> {
  __$$ReviewMissionRequestImplCopyWithImpl(_$ReviewMissionRequestImpl _value,
      $Res Function(_$ReviewMissionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onboardingId = null,
    Object? missionCode = null,
    Object? decision = null,
    Object? score = freezed,
    Object? comment = freezed,
  }) {
    return _then(_$ReviewMissionRequestImpl(
      onboardingId: null == onboardingId
          ? _value.onboardingId
          : onboardingId // ignore: cast_nullable_to_non_nullable
              as String,
      missionCode: null == missionCode
          ? _value.missionCode
          : missionCode // ignore: cast_nullable_to_non_nullable
              as String,
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewMissionRequestImpl implements _ReviewMissionRequest {
  const _$ReviewMissionRequestImpl(
      {required this.onboardingId,
      required this.missionCode,
      required this.decision,
      this.score,
      this.comment});

  factory _$ReviewMissionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewMissionRequestImplFromJson(json);

  @override
  final String onboardingId;
  @override
  final String missionCode;
  @override
  final String decision;
  @override
  final double? score;
  @override
  final String? comment;

  @override
  String toString() {
    return 'ReviewMissionRequest(onboardingId: $onboardingId, missionCode: $missionCode, decision: $decision, score: $score, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewMissionRequestImpl &&
            (identical(other.onboardingId, onboardingId) ||
                other.onboardingId == onboardingId) &&
            (identical(other.missionCode, missionCode) ||
                other.missionCode == missionCode) &&
            (identical(other.decision, decision) ||
                other.decision == decision) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, onboardingId, missionCode, decision, score, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewMissionRequestImplCopyWith<_$ReviewMissionRequestImpl>
      get copyWith =>
          __$$ReviewMissionRequestImplCopyWithImpl<_$ReviewMissionRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewMissionRequestImplToJson(
      this,
    );
  }
}

abstract class _ReviewMissionRequest implements ReviewMissionRequest {
  const factory _ReviewMissionRequest(
      {required final String onboardingId,
      required final String missionCode,
      required final String decision,
      final double? score,
      final String? comment}) = _$ReviewMissionRequestImpl;

  factory _ReviewMissionRequest.fromJson(Map<String, dynamic> json) =
      _$ReviewMissionRequestImpl.fromJson;

  @override
  String get onboardingId;
  @override
  String get missionCode;
  @override
  String get decision;
  @override
  double? get score;
  @override
  String? get comment;
  @override
  @JsonKey(ignore: true)
  _$$ReviewMissionRequestImplCopyWith<_$ReviewMissionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
