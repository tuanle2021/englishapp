// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizDataset _$QuizDatasetFromJson(Map<String, dynamic> json) => QuizDataset(
      id: json['id'] as String?,
      created_at: json['created_at'] as String?,
      quiz_id: json['quiz_id'] as String?,
      updated_at: json['updated_at'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      quiz_type: json['quiz_type'] as String?,
    );

Map<String, dynamic> _$QuizDatasetToJson(QuizDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quiz_id': instance.quiz_id,
      'quiz_type': instance.quiz_type,
      'isDeleted': instance.isDeleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
    };
