// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_fill_char_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizFillCharDataset _$QuizFillCharDatasetFromJson(Map<String, dynamic> json) =>
    QuizFillCharDataset(
      id: json['id'] as String?,
      created_at: json['created_at'] as String?,
      lessonId: json['lessonId'] as String?,
      wordId: json['wordId'] as String?,
      type: json['type'] as String?,
      updated_at: json['updated_at'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      name: json['name'] as String?,
    )..quizType = $enumDecodeNullable(_$QuizTypeEnumMap, json['quizType']);

Map<String, dynamic> _$QuizFillCharDatasetToJson(
        QuizFillCharDataset instance) =>
    <String, dynamic>{
      'quizType': _$QuizTypeEnumMap[instance.quizType],
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'lessonId': instance.lessonId,
      'wordId': instance.wordId,
      'isDeleted': instance.isDeleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
    };

const _$QuizTypeEnumMap = {
  QuizType.FillChar: 'FillChar',
  QuizType.FillWord: 'FillWord',
  QuizType.RightPronouce: 'RightPronouce',
  QuizType.RightWord: 'RightWord',
  QuizType.TransArrange: 'TransArrange',
};
