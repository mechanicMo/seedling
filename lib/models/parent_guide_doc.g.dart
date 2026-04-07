// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_guide_doc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParentGuideDocImpl _$$ParentGuideDocImplFromJson(Map<String, dynamic> json) =>
    _$ParentGuideDocImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      ageRanges: (json['ageRanges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      situationTags: (json['situationTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      quickResponse: json['quickResponse'] as String,
      fullGuide: json['fullGuide'] as String,
      researchBasis: (json['researchBasis'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      doThis: (json['doThis'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notThat: (json['notThat'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      followUpActivityIds: (json['followUpActivityIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      published: json['published'] as bool? ?? true,
      version: (json['version'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$ParentGuideDocImplToJson(
        _$ParentGuideDocImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'ageRanges': instance.ageRanges,
      'situationTags': instance.situationTags,
      'quickResponse': instance.quickResponse,
      'fullGuide': instance.fullGuide,
      'researchBasis': instance.researchBasis,
      'doThis': instance.doThis,
      'notThat': instance.notThat,
      'followUpActivityIds': instance.followUpActivityIds,
      'published': instance.published,
      'version': instance.version,
    };
