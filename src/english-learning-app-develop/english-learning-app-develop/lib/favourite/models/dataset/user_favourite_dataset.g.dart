// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_favourite_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFavouriteDataset _$UserFavouriteDatasetFromJson(
        Map<String, dynamic> json) =>
    UserFavouriteDataset(
      id: json['id'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      userId: json['userId'] as String?,
      wordId: json['wordId'] as String?,
    );

Map<String, dynamic> _$UserFavouriteDatasetToJson(
        UserFavouriteDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wordId': instance.wordId,
      'userId': instance.userId,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
    };
