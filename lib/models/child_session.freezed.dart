// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChildSession _$ChildSessionFromJson(Map<String, dynamic> json) {
  return _ChildSession.fromJson(json);
}

/// @nodoc
mixin _$ChildSession {
  String get id => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  List<String> get activityIds => throw _privateConstructorUsedError;
  SessionReport? get report => throw _privateConstructorUsedError;

  /// Serializes this ChildSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildSessionCopyWith<ChildSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildSessionCopyWith<$Res> {
  factory $ChildSessionCopyWith(
          ChildSession value, $Res Function(ChildSession) then) =
      _$ChildSessionCopyWithImpl<$Res, ChildSession>;
  @useResult
  $Res call(
      {String id,
      DateTime startedAt,
      DateTime? endedAt,
      int durationMinutes,
      List<String> activityIds,
      SessionReport? report});

  $SessionReportCopyWith<$Res>? get report;
}

/// @nodoc
class _$ChildSessionCopyWithImpl<$Res, $Val extends ChildSession>
    implements $ChildSessionCopyWith<$Res> {
  _$ChildSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? durationMinutes = null,
    Object? activityIds = null,
    Object? report = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      activityIds: null == activityIds
          ? _value.activityIds
          : activityIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      report: freezed == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as SessionReport?,
    ) as $Val);
  }

  /// Create a copy of ChildSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionReportCopyWith<$Res>? get report {
    if (_value.report == null) {
      return null;
    }

    return $SessionReportCopyWith<$Res>(_value.report!, (value) {
      return _then(_value.copyWith(report: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChildSessionImplCopyWith<$Res>
    implements $ChildSessionCopyWith<$Res> {
  factory _$$ChildSessionImplCopyWith(
          _$ChildSessionImpl value, $Res Function(_$ChildSessionImpl) then) =
      __$$ChildSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startedAt,
      DateTime? endedAt,
      int durationMinutes,
      List<String> activityIds,
      SessionReport? report});

  @override
  $SessionReportCopyWith<$Res>? get report;
}

/// @nodoc
class __$$ChildSessionImplCopyWithImpl<$Res>
    extends _$ChildSessionCopyWithImpl<$Res, _$ChildSessionImpl>
    implements _$$ChildSessionImplCopyWith<$Res> {
  __$$ChildSessionImplCopyWithImpl(
      _$ChildSessionImpl _value, $Res Function(_$ChildSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChildSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? durationMinutes = null,
    Object? activityIds = null,
    Object? report = freezed,
  }) {
    return _then(_$ChildSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      activityIds: null == activityIds
          ? _value._activityIds
          : activityIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      report: freezed == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as SessionReport?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildSessionImpl implements _ChildSession {
  const _$ChildSessionImpl(
      {required this.id,
      required this.startedAt,
      this.endedAt,
      this.durationMinutes = 0,
      final List<String> activityIds = const [],
      this.report})
      : _activityIds = activityIds;

  factory _$ChildSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildSessionImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;
  @override
  @JsonKey()
  final int durationMinutes;
  final List<String> _activityIds;
  @override
  @JsonKey()
  List<String> get activityIds {
    if (_activityIds is EqualUnmodifiableListView) return _activityIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activityIds);
  }

  @override
  final SessionReport? report;

  @override
  String toString() {
    return 'ChildSession(id: $id, startedAt: $startedAt, endedAt: $endedAt, durationMinutes: $durationMinutes, activityIds: $activityIds, report: $report)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            const DeepCollectionEquality()
                .equals(other._activityIds, _activityIds) &&
            (identical(other.report, report) || other.report == report));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      startedAt,
      endedAt,
      durationMinutes,
      const DeepCollectionEquality().hash(_activityIds),
      report);

  /// Create a copy of ChildSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildSessionImplCopyWith<_$ChildSessionImpl> get copyWith =>
      __$$ChildSessionImplCopyWithImpl<_$ChildSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildSessionImplToJson(
      this,
    );
  }
}

abstract class _ChildSession implements ChildSession {
  const factory _ChildSession(
      {required final String id,
      required final DateTime startedAt,
      final DateTime? endedAt,
      final int durationMinutes,
      final List<String> activityIds,
      final SessionReport? report}) = _$ChildSessionImpl;

  factory _ChildSession.fromJson(Map<String, dynamic> json) =
      _$ChildSessionImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startedAt;
  @override
  DateTime? get endedAt;
  @override
  int get durationMinutes;
  @override
  List<String> get activityIds;
  @override
  SessionReport? get report;

  /// Create a copy of ChildSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildSessionImplCopyWith<_$ChildSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
