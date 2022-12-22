// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_right_word_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizRightWordDataset _$QuizRightWordDatasetFromJson(
        Map<String, dynamic> json) =>
    QuizRightWordDataset(
      id: json['id'] as String?,
      created_at: json['created_at'] as String?,
      lessonId: json['lessonId'] as String?,
      wordId: json['wordId'] as String?,
      type: json['type'] as String?,
      updated_at: json['updated_at'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      correctChoice: json['correctChoice'] as String?,
      firstChoice: json['firstChoice'] as String?,
      name: json['name'] as String?,
      secondChoice: json['secondChoice'] as String?,
      thirdChoice: json['thirdChoice'] as String?,
    )..quizType = $enumDecodeNullable(_$QuizTypeEnumMap, json['quizType']);

Map<String, dynamic> _$QuizRightWordDatasetToJson(
        QuizRightWordDataset instance) =>
    <String, dynamic>{
      'quizType': _$QuizTypeEnumMap[instance.quizType],
      'id': instance.id,
      'name': instance.name,
      'lessonId': instance.lessonId,
      'type': instance.type,
      'wordId': instance.wordId,
      'correctChoice': instance.correctChoice,
      'firstChoice': instance.firstChoice,
      'secondChoice': instance.secondChoice,
      'thirdChoice': instance.thirdChoice,
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
