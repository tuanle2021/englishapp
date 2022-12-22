// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_user_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonUserDataset _$LessonUserDatasetFromJson(Map<String, dynamic> json) =>
    LessonUserDataset(
      id: json['id'] as String,
      isBlock: json['isBlock'] as bool?,
      isCompleted: json['isCompleted'] as bool?,
      userId: json['userId'] as String?,
      lessonId: json['lessonId'] as String?,
    )
      ..updated_at = json['updated_at'] as String?
      ..created_at = json['created_at'] as String?;

Map<String, dynamic> _$LessonUserDatasetToJson(LessonUserDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lessonId': instance.lessonId,
      'userId': instance.userId,
      'isBlock': instance.isBlock,
      'isCompleted': instance.isCompleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
    };
