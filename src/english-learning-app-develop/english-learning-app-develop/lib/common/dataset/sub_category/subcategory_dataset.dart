import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
part 'subcategory_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'SUBCATEGORY')
class SubCategoryDataset {
  SubCategoryDataset({
    this.id,
    this.created_at,
    this.name,
    this.updated_at,
    this.isDeleted,
    this.category,
  });

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "name")
  String? name;

  @ColumnInfo(name: "category")
  String? category;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  @ignore
  @JsonKey(ignore: true)
  List<LessonDataset?>? lessonList;

  factory SubCategoryDataset.fromJson(Map<String, dynamic> data) =>
      _$SubCategoryDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$SubCategoryDatasetToJson(this);
}
