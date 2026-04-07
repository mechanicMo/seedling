// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildActivityImpl _$$ChildActivityImplFromJson(Map<String, dynamic> json) =>
    _$ChildActivityImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      ageRanges: (json['ageRanges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 5,
      mediaRefs: (json['mediaRefs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skillsTargeted: (json['skillsTargeted'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      learningObjectives: (json['learningObjectives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parentFollowUp: json['parentFollowUp'] as String? ?? '',
      published: json['published'] as bool? ?? false,
      version: (json['version'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$ChildActivityImplToJson(_$ChildActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'ageRanges': instance.ageRanges,
      'durationMinutes': instance.durationMinutes,
      'mediaRefs': instance.mediaRefs,
      'skillsTargeted': instance.skillsTargeted,
      'learningObjectives': instance.learningObjectives,
      'parentFollowUp': instance.parentFollowUp,
      'published': instance.published,
      'version': instance.version,
    };
