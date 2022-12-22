// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordDataset _$WordDatasetFromJson(Map<String, dynamic> json) => WordDataset(
      json['id'] as String?,
      json['word_id'] as String?,
      json['word'] as String?,
      json['lexicalCategory'] as String?,
      json['type'] as String?,
      json['ori_lang'] as String?,
      json['tra_lang'] as String?,
      json['definitions'] as String?,
      json['shortDefinitions'] as String?,
      json['examples'] as String?,
      json['phoneticNotation'] as String?,
      json['phoneticSpelling'] as String?,
      json['audioFile'] as String?,
      json['synonyms'] as String?,
      json['phrases'] as String?,
      json['mean'] as String?,
      json['category'] as String?,
      json['level'] as String?,
    )..image = json['image'] as String?;

Map<String, dynamic> _$WordDatasetToJson(WordDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word_id': instance.word_id,
      'word': instance.word,
      'lexicalCategory': instance.lexicalCategory,
      'type': instance.type,
      'ori_lang': instance.ori_lang,
      'tra_lang': instance.tra_lang,
      'definitions': instance.definitions,
      'shortDefinitions': instance.shortDefinitions,
      'examples': instance.examples,
      'phoneticNotation': instance.phoneticNotation,
      'phoneticSpelling': instance.phoneticSpelling,
      'audioFile': instance.audioFile,
      'synonyms': instance.synonyms,
      'phrases': instance.phrases,
      'mean': instance.mean,
      'category': instance.category,
      'level': instance.level,
      'image': instance.image,
    };
