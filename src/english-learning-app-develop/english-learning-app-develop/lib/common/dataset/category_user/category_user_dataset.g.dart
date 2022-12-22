// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_user_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryUserDataset _$CategoryUserDatasetFromJson(Map<String, dynamic> json) =>
    CategoryUserDataset(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      progress: json['progress'] as int?,
      userId: json['userId'] as String?,
    )
      ..updated_at = json['updated_at'] as String?
      ..created_at = json['created_at'] as String?;

Map<String, dynamic> _$CategoryUserDatasetToJson(
        CategoryUserDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'categoryId': instance.categoryId,
      'progress': instance.progress,
      'isDeleted': instance.isDeleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
    };
