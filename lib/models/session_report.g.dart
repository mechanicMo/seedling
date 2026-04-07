// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionReportImpl _$$SessionReportImplFromJson(Map<String, dynamic> json) =>
    _$SessionReportImpl(
      summary: json['summary'] as String,
      skillsPracticed: (json['skillsPracticed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parentFollowUps: (json['parentFollowUps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      aiObservations: json['aiObservations'] as String? ?? '',
    );

Map<String, dynamic> _$$SessionReportImplToJson(_$SessionReportImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'skillsPracticed': instance.skillsPracticed,
      'parentFollowUps': instance.parentFollowUps,
      'aiObservations': instance.aiObservations,
    };
