// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_trans_arrange_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizTransArrangeDataset _$QuizTransArrangeDatasetFromJson(
        Map<String, dynamic> json) =>
    QuizTransArrangeDataset(
      id: json['id'] as String?,
      created_at: json['created_at'] as String?,
      lessonId: json['lessonId'] as String?,
      wordId: json['wordId'] as String?,
      type: json['type'] as String?,
      updated_at: json['updated_at'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      name: json['name'] as String?,
      originSentence: json['originSentence'] as String?,
      viSentence: json['viSentence'] as String?,
      numRightPhrase: json['numRightPhrase'] as int?,
      viPhrase: (json['viPhrase'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )..quizType = $enumDecodeNullable(_$QuizTypeEnumMap, json['quizType']);

Map<String, dynamic> _$QuizTransArrangeDatasetToJson(
        QuizTransArrangeDataset instance) =>
    <String, dynamic>{
      'quizType': _$QuizTypeEnumMap[instance.quizType],
      'id': instance.id,
      'name': instance.name,
      'lessonId': instance.lessonId,
      'type': instance.type,
      'wordId': instance.wordId,
      'originSentence': instance.originSentence,
      'viSentence': instance.viSentence,
      'isDeleted': instance.isDeleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
      'numRightPhrase': instance.numRightPhrase,
      'viPhrase': instance.viPhrase,
    };

const _$QuizTypeEnumMap = {
  QuizType.FillChar: 'FillChar',
  QuizType.FillWord: 'FillWord',
  QuizType.RightPronouce: 'RightPronouce',
  QuizType.RightWord: 'RightWord',
  QuizType.TransArrange: 'TransArrange',
};
