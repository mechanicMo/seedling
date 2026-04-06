// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentSelectionImpl _$$ContentSelectionImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentSelectionImpl(
      enabledCategories: (json['enabledCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          AppConstants.allCategories,
      enabledActivityTypes: (json['enabledActivityTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          AppConstants.allActivityTypes,
    );

Map<String, dynamic> _$$ContentSelectionImplToJson(
        _$ContentSelectionImpl instance) =>
    <String, dynamic>{
      'enabledCategories': instance.enabledCategories,
      'enabledActivityTypes': instance.enabledActivityTypes,
    };

_$ChildProfileImpl _$$ChildProfileImplFromJson(Map<String, dynamic> json) =>
    _$ChildProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      ageRange: json['ageRange'] as String,
      sessionTimerMinutes: (json['sessionTimerMinutes'] as num?)?.toInt() ??
          AppConstants.defaultSessionTimerMinutes,
      contentSelection: json['contentSelection'] == null
          ? const ContentSelection()
          : ContentSelection.fromJson(
              json['contentSelection'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChildProfileImplToJson(_$ChildProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthDate': instance.birthDate.toIso8601String(),
      'ageRange': instance.ageRange,
      'sessionTimerMinutes': instance.sessionTimerMinutes,
      'contentSelection': instance.contentSelection,
    };
