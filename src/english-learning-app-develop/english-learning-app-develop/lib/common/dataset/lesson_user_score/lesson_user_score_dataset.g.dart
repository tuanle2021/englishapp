// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_user_score_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonUserScoreDataset _$LessonUserScoreDatasetFromJson(
        Map<String, dynamic> json) =>
    LessonUserScoreDataset(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
      userId: json['userId'] as String,
      completedAt: json['completedAt'] as String?,
      completionTime: json['completionTime'] as String?,
      point: json['point'] as int?,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      totalCorrect: json['totalCorrect'] as int?,
      totalIncorrect: json['totalIncorrect'] as int?,
    );

Map<String, dynamic> _$LessonUserScoreDatasetToJson(
        LessonUserScoreDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalIncorrect': instance.totalIncorrect,
      'totalCorrect': instance.totalCorrect,
      'point': instance.point,
      'completionTime': instance.completionTime,
      'completedAt': instance.completedAt,
      'accuracy': instance.accuracy,
      'userId': instance.userId,
      'lessonId': instance.lessonId,
    };
