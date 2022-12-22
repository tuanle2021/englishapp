// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonDataset _$LessonDatasetFromJson(Map<String, dynamic> json) =>
    LessonDataset(
      id: json['id'] as String?,
      created_at: json['created_at'] as String?,
      name: json['name'] as String?,
      updated_at: json['updated_at'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      subCategory: json['subCategory'] as String?,
    );

Map<String, dynamic> _$LessonDatasetToJson(LessonDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subCategory': instance.subCategory,
      'isDeleted': instance.isDeleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
    };
