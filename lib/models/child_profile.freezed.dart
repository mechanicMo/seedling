// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentSelection _$ContentSelectionFromJson(Map<String, dynamic> json) {
  return _ContentSelection.fromJson(json);
}

/// @nodoc
mixin _$ContentSelection {
  List<String> get enabledCategories => throw _privateConstructorUsedError;
  List<String> get enabledActivityTypes => throw _privateConstructorUsedError;

  /// Serializes this ContentSelection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentSelectionCopyWith<ContentSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentSelectionCopyWith<$Res> {
  factory $ContentSelectionCopyWith(
          ContentSelection value, $Res Function(ContentSelection) then) =
      _$ContentSelectionCopyWithImpl<$Res, ContentSelection>;
  @useResult
  $Res call(
      {List<String> enabledCategories, List<String> enabledActivityTypes});
}

/// @nodoc
class _$ContentSelectionCopyWithImpl<$Res, $Val extends ContentSelection>
    implements $ContentSelectionCopyWith<$Res> {
  _$ContentSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabledCategories = null,
    Object? enabledActivityTypes = null,
  }) {
    return _then(_value.copyWith(
      enabledCategories: null == enabledCategories
          ? _value.enabledCategories
          : enabledCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      enabledActivityTypes: null == enabledActivityTypes
          ? _value.enabledActivityTypes
          : enabledActivityTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentSelectionImplCopyWith<$Res>
    implements $ContentSelectionCopyWith<$Res> {
  factory _$$ContentSelectionImplCopyWith(_$ContentSelectionImpl value,
          $Res Function(_$ContentSelectionImpl) then) =
      __$$ContentSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> enabledCategories, List<String> enabledActivityTypes});
}

/// @nodoc
class __$$ContentSelectionImplCopyWithImpl<$Res>
    extends _$ContentSelectionCopyWithImpl<$Res, _$ContentSelectionImpl>
    implements _$$ContentSelectionImplCopyWith<$Res> {
  __$$ContentSelectionImplCopyWithImpl(_$ContentSelectionImpl _value,
      $Res Function(_$ContentSelectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabledCategories = null,
    Object? enabledActivityTypes = null,
  }) {
    return _then(_$ContentSelectionImpl(
      enabledCategories: null == enabledCategories
          ? _value._enabledCategories
          : enabledCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      enabledActivityTypes: null == enabledActivityTypes
          ? _value._enabledActivityTypes
          : enabledActivityTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentSelectionImpl implements _ContentSelection {
  const _$ContentSelectionImpl(
      {final List<String> enabledCategories = AppConstants.allCategories,
      final List<String> enabledActivityTypes = AppConstants.allActivityTypes})
      : _enabledCategories = enabledCategories,
        _enabledActivityTypes = enabledActivityTypes;

  factory _$ContentSelectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentSelectionImplFromJson(json);

  final List<String> _enabledCategories;
  @override
  @JsonKey()
  List<String> get enabledCategories {
    if (_enabledCategories is EqualUnmodifiableListView)
      return _enabledCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enabledCategories);
  }

  final List<String> _enabledActivityTypes;
  @override
  @JsonKey()
  List<String> get enabledActivityTypes {
    if (_enabledActivityTypes is EqualUnmodifiableListView)
      return _enabledActivityTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enabledActivityTypes);
  }

  @override
  String toString() {
    return 'ContentSelection(enabledCategories: $enabledCategories, enabledActivityTypes: $enabledActivityTypes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentSelectionImpl &&
            const DeepCollectionEquality()
                .equals(other._enabledCategories, _enabledCategories) &&
            const DeepCollectionEquality()
                .equals(other._enabledActivityTypes, _enabledActivityTypes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_enabledCategories),
      const DeepCollectionEquality().hash(_enabledActivityTypes));

  /// Create a copy of ContentSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentSelectionImplCopyWith<_$ContentSelectionImpl> get copyWith =>
      __$$ContentSelectionImplCopyWithImpl<_$ContentSelectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentSelectionImplToJson(
      this,
    );
  }
}

abstract class _ContentSelection implements ContentSelection {
  const factory _ContentSelection(
      {final List<String> enabledCategories,
      final List<String> enabledActivityTypes}) = _$ContentSelectionImpl;

  factory _ContentSelection.fromJson(Map<String, dynamic> json) =
      _$ContentSelectionImpl.fromJson;

  @override
  List<String> get enabledCategories;
  @override
  List<String> get enabledActivityTypes;

  /// Create a copy of ContentSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentSelectionImplCopyWith<_$ContentSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChildProfile _$ChildProfileFromJson(Map<String, dynamic> json) {
  return _ChildProfile.fromJson(json);
}

/// @nodoc
mixin _$ChildProfile {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get birthDate => throw _privateConstructorUsedError;
  String get ageRange => throw _privateConstructorUsedError;
  int get sessionTimerMinutes => throw _privateConstructorUsedError;
  ContentSelection get contentSelection => throw _privateConstructorUsedError;

  /// Serializes this ChildProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildProfileCopyWith<ChildProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildProfileCopyWith<$Res> {
  factory $ChildProfileCopyWith(
          ChildProfile value, $Res Function(ChildProfile) then) =
      _$ChildProfileCopyWithImpl<$Res, ChildProfile>;
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime birthDate,
      String ageRange,
      int sessionTimerMinutes,
      ContentSelection contentSelection});

  $ContentSelectionCopyWith<$Res> get contentSelection;
}

/// @nodoc
class _$ChildProfileCopyWithImpl<$Res, $Val extends ChildProfile>
    implements $ChildProfileCopyWith<$Res> {
  _$ChildProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? birthDate = null,
    Object? ageRange = null,
    Object? sessionTimerMinutes = null,
    Object? contentSelection = null,
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
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageRange: null == ageRange
          ? _value.ageRange
          : ageRange // ignore: cast_nullable_to_non_nullable
              as String,
      sessionTimerMinutes: null == sessionTimerMinutes
          ? _value.sessionTimerMinutes
          : sessionTimerMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      contentSelection: null == contentSelection
          ? _value.contentSelection
          : contentSelection // ignore: cast_nullable_to_non_nullable
              as ContentSelection,
    ) as $Val);
  }

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContentSelectionCopyWith<$Res> get contentSelection {
    return $ContentSelectionCopyWith<$Res>(_value.contentSelection, (value) {
      return _then(_value.copyWith(contentSelection: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChildProfileImplCopyWith<$Res>
    implements $ChildProfileCopyWith<$Res> {
  factory _$$ChildProfileImplCopyWith(
          _$ChildProfileImpl value, $Res Function(_$ChildProfileImpl) then) =
      __$$ChildProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime birthDate,
      String ageRange,
      int sessionTimerMinutes,
      ContentSelection contentSelection});

  @override
  $ContentSelectionCopyWith<$Res> get contentSelection;
}

/// @nodoc
class __$$ChildProfileImplCopyWithImpl<$Res>
    extends _$ChildProfileCopyWithImpl<$Res, _$ChildProfileImpl>
    implements _$$ChildProfileImplCopyWith<$Res> {
  __$$ChildProfileImplCopyWithImpl(
      _$ChildProfileImpl _value, $Res Function(_$ChildProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? birthDate = null,
    Object? ageRange = null,
    Object? sessionTimerMinutes = null,
    Object? contentSelection = null,
  }) {
    return _then(_$ChildProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageRange: null == ageRange
          ? _value.ageRange
          : ageRange // ignore: cast_nullable_to_non_nullable
              as String,
      sessionTimerMinutes: null == sessionTimerMinutes
          ? _value.sessionTimerMinutes
          : sessionTimerMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      contentSelection: null == contentSelection
          ? _value.contentSelection
          : contentSelection // ignore: cast_nullable_to_non_nullable
              as ContentSelection,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildProfileImpl extends _ChildProfile {
  const _$ChildProfileImpl(
      {required this.id,
      required this.name,
      required this.birthDate,
      required this.ageRange,
      this.sessionTimerMinutes = AppConstants.defaultSessionTimerMinutes,
      this.contentSelection = const ContentSelection()})
      : super._();

  factory _$ChildProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime birthDate;
  @override
  final String ageRange;
  @override
  @JsonKey()
  final int sessionTimerMinutes;
  @override
  @JsonKey()
  final ContentSelection contentSelection;

  @override
  String toString() {
    return 'ChildProfile(id: $id, name: $name, birthDate: $birthDate, ageRange: $ageRange, sessionTimerMinutes: $sessionTimerMinutes, contentSelection: $contentSelection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.ageRange, ageRange) ||
                other.ageRange == ageRange) &&
            (identical(other.sessionTimerMinutes, sessionTimerMinutes) ||
                other.sessionTimerMinutes == sessionTimerMinutes) &&
            (identical(other.contentSelection, contentSelection) ||
                other.contentSelection == contentSelection));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, birthDate, ageRange,
      sessionTimerMinutes, contentSelection);

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildProfileImplCopyWith<_$ChildProfileImpl> get copyWith =>
      __$$ChildProfileImplCopyWithImpl<_$ChildProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildProfileImplToJson(
      this,
    );
  }
}

abstract class _ChildProfile extends ChildProfile {
  const factory _ChildProfile(
      {required final String id,
      required final String name,
      required final DateTime birthDate,
      required final String ageRange,
      final int sessionTimerMinutes,
      final ContentSelection contentSelection}) = _$ChildProfileImpl;
  const _ChildProfile._() : super._();

  factory _ChildProfile.fromJson(Map<String, dynamic> json) =
      _$ChildProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get birthDate;
  @override
  String get ageRange;
  @override
  int get sessionTimerMinutes;
  @override
  ContentSelection get contentSelection;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildProfileImplCopyWith<_$ChildProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
