import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
part 'quiz_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'QUIZ')
class QuizDataset {
  QuizDataset({
    this.id,
    this.created_at,
    this.quiz_id,
    this.updated_at,
    this.isDeleted,
    this.quiz_type,
  });

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "quiz_id")
  String? quiz_id;

  @ColumnInfo(name: "quiz_type")
  String? quiz_type;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;


  factory QuizDataset.fromJson(Map<String, dynamic> data) =>
      _$QuizDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$QuizDatasetToJson(this);
}
