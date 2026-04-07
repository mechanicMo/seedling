// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SessionReport _$SessionReportFromJson(Map<String, dynamic> json) {
  return _SessionReport.fromJson(json);
}

/// @nodoc
mixin _$SessionReport {
  String get summary => throw _privateConstructorUsedError;
  List<String> get skillsPracticed => throw _privateConstructorUsedError;
  List<String> get parentFollowUps => throw _privateConstructorUsedError;
  String get aiObservations => throw _privateConstructorUsedError;

  /// Serializes this SessionReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionReportCopyWith<SessionReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionReportCopyWith<$Res> {
  factory $SessionReportCopyWith(
          SessionReport value, $Res Function(SessionReport) then) =
      _$SessionReportCopyWithImpl<$Res, SessionReport>;
  @useResult
  $Res call(
      {String summary,
      List<String> skillsPracticed,
      List<String> parentFollowUps,
      String aiObservations});
}

/// @nodoc
class _$SessionReportCopyWithImpl<$Res, $Val extends SessionReport>
    implements $SessionReportCopyWith<$Res> {
  _$SessionReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? skillsPracticed = null,
    Object? parentFollowUps = null,
    Object? aiObservations = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      skillsPracticed: null == skillsPracticed
          ? _value.skillsPracticed
          : skillsPracticed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parentFollowUps: null == parentFollowUps
          ? _value.parentFollowUps
          : parentFollowUps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aiObservations: null == aiObservations
          ? _value.aiObservations
          : aiObservations // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionReportImplCopyWith<$Res>
    implements $SessionReportCopyWith<$Res> {
  factory _$$SessionReportImplCopyWith(
          _$SessionReportImpl value, $Res Function(_$SessionReportImpl) then) =
      __$$SessionReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String summary,
      List<String> skillsPracticed,
      List<String> parentFollowUps,
      String aiObservations});
}

/// @nodoc
class __$$SessionReportImplCopyWithImpl<$Res>
    extends _$SessionReportCopyWithImpl<$Res, _$SessionReportImpl>
    implements _$$SessionReportImplCopyWith<$Res> {
  __$$SessionReportImplCopyWithImpl(
      _$SessionReportImpl _value, $Res Function(_$SessionReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? skillsPracticed = null,
    Object? parentFollowUps = null,
    Object? aiObservations = null,
  }) {
    return _then(_$SessionReportImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      skillsPracticed: null == skillsPracticed
          ? _value._skillsPracticed
          : skillsPracticed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parentFollowUps: null == parentFollowUps
          ? _value._parentFollowUps
          : parentFollowUps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aiObservations: null == aiObservations
          ? _value.aiObservations
          : aiObservations // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionReportImpl implements _SessionReport {
  const _$SessionReportImpl(
      {required this.summary,
      final List<String> skillsPracticed = const [],
      final List<String> parentFollowUps = const [],
      this.aiObservations = ''})
      : _skillsPracticed = skillsPracticed,
        _parentFollowUps = parentFollowUps;

  factory _$SessionReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionReportImplFromJson(json);

  @override
  final String summary;
  final List<String> _skillsPracticed;
  @override
  @JsonKey()
  List<String> get skillsPracticed {
    if (_skillsPracticed is EqualUnmodifiableListView) return _skillsPracticed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsPracticed);
  }

  final List<String> _parentFollowUps;
  @override
  @JsonKey()
  List<String> get parentFollowUps {
    if (_parentFollowUps is EqualUnmodifiableListView) return _parentFollowUps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parentFollowUps);
  }

  @override
  @JsonKey()
  final String aiObservations;

  @override
  String toString() {
    return 'SessionReport(summary: $summary, skillsPracticed: $skillsPracticed, parentFollowUps: $parentFollowUps, aiObservations: $aiObservations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionReportImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._skillsPracticed, _skillsPracticed) &&
            const DeepCollectionEquality()
                .equals(other._parentFollowUps, _parentFollowUps) &&
            (identical(other.aiObservations, aiObservations) ||
                other.aiObservations == aiObservations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_skillsPracticed),
      const DeepCollectionEquality().hash(_parentFollowUps),
      aiObservations);

  /// Create a copy of SessionReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionReportImplCopyWith<_$SessionReportImpl> get copyWith =>
      __$$SessionReportImplCopyWithImpl<_$SessionReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionReportImplToJson(
      this,
    );
  }
}

abstract class _SessionReport implements SessionReport {
  const factory _SessionReport(
      {required final String summary,
      final List<String> skillsPracticed,
      final List<String> parentFollowUps,
      final String aiObservations}) = _$SessionReportImpl;

  factory _SessionReport.fromJson(Map<String, dynamic> json) =
      _$SessionReportImpl.fromJson;

  @override
  String get summary;
  @override
  List<String> get skillsPracticed;
  @override
  List<String> get parentFollowUps;
  @override
  String get aiObservations;

  /// Create a copy of SessionReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionReportImplCopyWith<_$SessionReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
