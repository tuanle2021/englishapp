import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';
part 'lesson_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'LESSON')
class LessonDataset {
  LessonDataset({
    this.id,
    this.created_at,
    this.name,
    this.updated_at,
    this.isDeleted,
    this.subCategory,
  });

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "name")
  String? name;

  @ColumnInfo(name: "subCategory")
  String? subCategory;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  @ignore
  @JsonKey(ignore: true)
  String? completedAt;

  @ignore
  @JsonKey(ignore: true)
  int? totalIncorrect;

  @ignore
  @JsonKey(ignore: true)
  double? accuracy;

  @ignore
  @JsonKey(ignore: true)
  String? completionTime;

  @ignore
  @JsonKey(ignore: true)
  int? isCompleted;

  @ignore
  @JsonKey(ignore: true)
  int? isBlock;

  @ignore
  @JsonKey(ignore: true)
  int? point;

  factory LessonDataset.fromJson(Map<String, dynamic> data) =>
      _$LessonDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$LessonDatasetToJson(this);
}
