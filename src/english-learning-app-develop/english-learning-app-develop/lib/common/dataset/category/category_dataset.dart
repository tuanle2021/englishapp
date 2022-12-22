import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/dataset/category_user/category_user_dataset.dart';
part 'category_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'CATEGORIES')
class CategoryDataset {
  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "name")
  String? name;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  @ColumnInfo(name: "levelType")
  String? levelType;

  @ColumnInfo(name: 'image')
  String? image;

  @JsonKey(ignore: true)
  @ignore
  int? total;

  @JsonKey(ignore: true)
  @ignore
  int? levelTypeValue;

  @JsonKey(ignore: true)
  @ignore
  int? completed;

  @JsonKey(ignore: true)
  @ignore
  double radius = logicalWidth * 0.15;

  @JsonKey(ignore: true)
  @ignore
  double isPressOpacity = 1;

  @JsonKey(ignore: true)
  @ignore
  bool isOpenDialog = false;

  @JsonKey(ignore: true)
  @ignore
  int scaleTransition = 0;

  @JsonKey(ignore: true)
  @ignore
  late CategoryUserDataset categoryUserDataset;

  @JsonKey(ignore: true)
  @ignore
  bool isLock = false;

  @JsonKey(ignore: true)
  @ignore
  final double disableOpacity = 0.5;

  @JsonKey(ignore: true)
  @ignore
  Image? iconImage;

  @JsonKey(ignore: true)
  @ignore
  final double originalRadius = logicalWidth * 0.15;

  double calculatePercent() {
    if (this.completed != null && this.total != null) {
      if (this.completed == 0) {
        return 0;
      }
      return this.completed!.toDouble() / this.total!.toDouble();
    }
    return 0;
  }

  String displayProgress() {
    if (this.completed != null && this.total != null) {
      return this.completed!.toInt().toString() +
          "/" +
          this.total!.toInt().toString();
    }
    return "";
  }

  CategoryDataset(
      {this.id,
      this.name,
      this.isDeleted,
      this.updated_at,
      this.created_at,
      this.image,
      this.levelType});

  factory CategoryDataset.fromJson(Map<String, dynamic> data) {
    var returnData = _$CategoryDatasetFromJson(data);
    switch (returnData.levelType) {
      case LevelType.BEGINNER:
        {
          returnData.levelTypeValue = 1;
          break;
        }
      case LevelType.INTERMEDIATE:
        {
          returnData.levelTypeValue = 2;
          break;
        }
      case LevelType.ADVANCED:
        {
          returnData.levelTypeValue = 3;
          break;
        }
      case LevelType.PROFESSIONAL:
        {
          returnData.levelTypeValue = 4;
          break;
        }
    }
    return returnData;
  }

  Map<String, dynamic> toJson() => _$CategoryDatasetToJson(this);
}
