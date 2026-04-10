// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChildActivity _$ChildActivityFromJson(Map<String, dynamic> json) {
  return _ChildActivity.fromJson(json);
}

/// @nodoc
mixin _$ChildActivity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // story | game | music | movement | video | creative
  String get contentType =>
      throw _privateConstructorUsedError; // story_pages | game_tap_match | game_memory | game_sequence | guided_steps
  Map<String, dynamic> get content =>
      throw _privateConstructorUsedError; // activity-specific content structure
  List<String> get ageRanges => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  List<String> get mediaRefs => throw _privateConstructorUsedError;
  List<String> get skillsTargeted => throw _privateConstructorUsedError;
  List<String> get learningObjectives => throw _privateConstructorUsedError;
  String get parentFollowUp => throw _privateConstructorUsedError;
  bool get published => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this ChildActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildActivityCopyWith<ChildActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildActivityCopyWith<$Res> {
  factory $ChildActivityCopyWith(
          ChildActivity value, $Res Function(ChildActivity) then) =
      _$ChildActivityCopyWithImpl<$Res, ChildActivity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String type,
      String contentType,
      Map<String, dynamic> content,
      List<String> ageRanges,
      int durationMinutes,
      List<String> mediaRefs,
      List<String> skillsTargeted,
      List<String> learningObjectives,
      String parentFollowUp,
      bool published,
      int version});
}

/// @nodoc
class _$ChildActivityCopyWithImpl<$Res, $Val extends ChildActivity>
    implements $ChildActivityCopyWith<$Res> {
  _$ChildActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? contentType = null,
    Object? content = null,
    Object? ageRanges = null,
    Object? durationMinutes = null,
    Object? mediaRefs = null,
    Object? skillsTargeted = null,
    Object? learningObjectives = null,
    Object? parentFollowUp = null,
    Object? published = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ageRanges: null == ageRanges
          ? _value.ageRanges
          : ageRanges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      mediaRefs: null == mediaRefs
          ? _value.mediaRefs
          : mediaRefs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skillsTargeted: null == skillsTargeted
          ? _value.skillsTargeted
          : skillsTargeted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      learningObjectives: null == learningObjectives
          ? _value.learningObjectives
          : learningObjectives // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parentFollowUp: null == parentFollowUp
          ? _value.parentFollowUp
          : parentFollowUp // ignore: cast_nullable_to_non_nullable
              as String,
      published: null == published
          ? _value.published
          : published // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChildActivityImplCopyWith<$Res>
    implements $ChildActivityCopyWith<$Res> {
  factory _$$ChildActivityImplCopyWith(
          _$ChildActivityImpl value, $Res Function(_$ChildActivityImpl) then) =
      __$$ChildActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String type,
      String contentType,
      Map<String, dynamic> content,
      List<String> ageRanges,
      int durationMinutes,
      List<String> mediaRefs,
      List<String> skillsTargeted,
      List<String> learningObjectives,
      String parentFollowUp,
      bool published,
      int version});
}

/// @nodoc
class __$$ChildActivityImplCopyWithImpl<$Res>
    extends _$ChildActivityCopyWithImpl<$Res, _$ChildActivityImpl>
    implements _$$ChildActivityImplCopyWith<$Res> {
  __$$ChildActivityImplCopyWithImpl(
      _$ChildActivityImpl _value, $Res Function(_$ChildActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChildActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? contentType = null,
    Object? content = null,
    Object? ageRanges = null,
    Object? durationMinutes = null,
    Object? mediaRefs = null,
    Object? skillsTargeted = null,
    Object? learningObjectives = null,
    Object? parentFollowUp = null,
    Object? published = null,
    Object? version = null,
  }) {
    return _then(_$ChildActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ageRanges: null == ageRanges
          ? _value._ageRanges
          : ageRanges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      mediaRefs: null == mediaRefs
          ? _value._mediaRefs
          : mediaRefs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skillsTargeted: null == skillsTargeted
          ? _value._skillsTargeted
          : skillsTargeted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      learningObjectives: null == learningObjectives
          ? _value._learningObjectives
          : learningObjectives // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parentFollowUp: null == parentFollowUp
          ? _value.parentFollowUp
          : parentFollowUp // ignore: cast_nullable_to_non_nullable
              as String,
      published: null == published
          ? _value.published
          : published // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildActivityImpl implements _ChildActivity {
  const _$ChildActivityImpl(
      {required this.id,
      required this.title,
      required this.type,
      this.contentType = 'story_pages',
      final Map<String, dynamic> content = const {},
      final List<String> ageRanges = const [],
      this.durationMinutes = 5,
      final List<String> mediaRefs = const [],
      final List<String> skillsTargeted = const [],
      final List<String> learningObjectives = const [],
      this.parentFollowUp = '',
      this.published = false,
      this.version = 1})
      : _content = content,
        _ageRanges = ageRanges,
        _mediaRefs = mediaRefs,
        _skillsTargeted = skillsTargeted,
        _learningObjectives = learningObjectives;

  factory _$ChildActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String type;
// story | game | music | movement | video | creative
  @override
  @JsonKey()
  final String contentType;
// story_pages | game_tap_match | game_memory | game_sequence | guided_steps
  final Map<String, dynamic> _content;
// story_pages | game_tap_match | game_memory | game_sequence | guided_steps
  @override
  @JsonKey()
  Map<String, dynamic> get content {
    if (_content is EqualUnmodifiableMapView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_content);
  }

// activity-specific content structure
  final List<String> _ageRanges;
// activity-specific content structure
  @override
  @JsonKey()
  List<String> get ageRanges {
    if (_ageRanges is EqualUnmodifiableListView) return _ageRanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ageRanges);
  }

  @override
  @JsonKey()
  final int durationMinutes;
  final List<String> _mediaRefs;
  @override
  @JsonKey()
  List<String> get mediaRefs {
    if (_mediaRefs is EqualUnmodifiableListView) return _mediaRefs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaRefs);
  }

  final List<String> _skillsTargeted;
  @override
  @JsonKey()
  List<String> get skillsTargeted {
    if (_skillsTargeted is EqualUnmodifiableListView) return _skillsTargeted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsTargeted);
  }

  final List<String> _learningObjectives;
  @override
  @JsonKey()
  List<String> get learningObjectives {
    if (_learningObjectives is EqualUnmodifiableListView)
      return _learningObjectives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_learningObjectives);
  }

  @override
  @JsonKey()
  final String parentFollowUp;
  @override
  @JsonKey()
  final bool published;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'ChildActivity(id: $id, title: $title, type: $type, contentType: $contentType, content: $content, ageRanges: $ageRanges, durationMinutes: $durationMinutes, mediaRefs: $mediaRefs, skillsTargeted: $skillsTargeted, learningObjectives: $learningObjectives, parentFollowUp: $parentFollowUp, published: $published, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            const DeepCollectionEquality()
                .equals(other._ageRanges, _ageRanges) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            const DeepCollectionEquality()
                .equals(other._mediaRefs, _mediaRefs) &&
            const DeepCollectionEquality()
                .equals(other._skillsTargeted, _skillsTargeted) &&
            const DeepCollectionEquality()
                .equals(other._learningObjectives, _learningObjectives) &&
            (identical(other.parentFollowUp, parentFollowUp) ||
                other.parentFollowUp == parentFollowUp) &&
            (identical(other.published, published) ||
                other.published == published) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      type,
      contentType,
      const DeepCollectionEquality().hash(_content),
      const DeepCollectionEquality().hash(_ageRanges),
      durationMinutes,
      const DeepCollectionEquality().hash(_mediaRefs),
      const DeepCollectionEquality().hash(_skillsTargeted),
      const DeepCollectionEquality().hash(_learningObjectives),
      parentFollowUp,
      published,
      version);

  /// Create a copy of ChildActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildActivityImplCopyWith<_$ChildActivityImpl> get copyWith =>
      __$$ChildActivityImplCopyWithImpl<_$ChildActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildActivityImplToJson(
      this,
    );
  }
}

abstract class _ChildActivity implements ChildActivity {
  const factory _ChildActivity(
      {required final String id,
      required final String title,
      required final String type,
      final String contentType,
      final Map<String, dynamic> content,
      final List<String> ageRanges,
      final int durationMinutes,
      final List<String> mediaRefs,
      final List<String> skillsTargeted,
      final List<String> learningObjectives,
      final String parentFollowUp,
      final bool published,
      final int version}) = _$ChildActivityImpl;

  factory _ChildActivity.fromJson(Map<String, dynamic> json) =
      _$ChildActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get type; // story | game | music | movement | video | creative
  @override
  String
      get contentType; // story_pages | game_tap_match | game_memory | game_sequence | guided_steps
  @override
  Map<String, dynamic> get content; // activity-specific content structure
  @override
  List<String> get ageRanges;
  @override
  int get durationMinutes;
  @override
  List<String> get mediaRefs;
  @override
  List<String> get skillsTargeted;
  @override
  List<String> get learningObjectives;
  @override
  String get parentFollowUp;
  @override
  bool get published;
  @override
  int get version;

  /// Create a copy of ChildActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildActivityImplCopyWith<_$ChildActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
