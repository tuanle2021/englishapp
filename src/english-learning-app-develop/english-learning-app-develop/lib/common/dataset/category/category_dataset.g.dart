// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDataset _$CategoryDatasetFromJson(Map<String, dynamic> json) =>
    CategoryDataset(
      id: json['id'] as String?,
      name: json['name'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      updated_at: json['updated_at'] as String?,
      created_at: json['created_at'] as String?,
      image: json['image'] as String?,
      levelType: json['levelType'] as String?,
    );

Map<String, dynamic> _$CategoryDatasetToJson(CategoryDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isDeleted': instance.isDeleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
      'levelType': instance.levelType,
      'image': instance.image,
    };
