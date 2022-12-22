// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_card_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCardDataset _$UserCardDatasetFromJson(Map<String, dynamic> json) =>
    UserCardDataset(
      id: json['id'] as String?,
      created_at: json['created_at'] as String?,
      catId: json['catId'] as String?,
      wordId: json['wordId'] as String?,
      due: (json['due'] as num?)?.toDouble(),
      ease: (json['ease'] as num?)?.toDouble(),
      interval: (json['interval'] as num?)?.toDouble(),
      isDeleted: json['isDeleted'] as bool?,
      original_interval: (json['original_interval'] as num?)?.toDouble(),
      phase: json['phase'] as int?,
      step: (json['step'] as num?)?.toDouble(),
      updated_at: json['updated_at'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$UserCardDatasetToJson(UserCardDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wordId': instance.wordId,
      'catId': instance.catId,
      'userId': instance.userId,
      'phase': instance.phase,
      'interval': instance.interval,
      'original_interval': instance.original_interval,
      'ease': instance.ease,
      'due': instance.due,
      'step': instance.step,
      'isDeleted': instance.isDeleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
    };
