// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategoryDataset _$SubCategoryDatasetFromJson(Map<String, dynamic> json) =>
    SubCategoryDataset(
      id: json['id'] as String?,
      created_at: json['created_at'] as String?,
      name: json['name'] as String?,
      updated_at: json['updated_at'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$SubCategoryDatasetToJson(SubCategoryDataset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'isDeleted': instance.isDeleted,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
    };
