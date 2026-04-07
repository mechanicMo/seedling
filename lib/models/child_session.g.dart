// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildSessionImpl _$$ChildSessionImplFromJson(Map<String, dynamic> json) =>
    _$ChildSessionImpl(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      activityIds: (json['activityIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      report: json['report'] == null
          ? null
          : SessionReport.fromJson(json['report'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChildSessionImplToJson(_$ChildSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'activityIds': instance.activityIds,
      'report': instance.report,
    };
