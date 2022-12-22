import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
part 'user_favourite_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'USER_FAVOURITE')
class UserFavouriteDataset {
  UserFavouriteDataset(
      {this.id, this.created_at, this.updated_at, this.userId, this.wordId});

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "wordId")
  String? wordId;

  @ColumnInfo(name: "userId")
  String? userId;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  @JsonKey(ignore: true)
  @ignore
  WordDataset? wordDataset;

  factory UserFavouriteDataset.fromJson(Map<String, dynamic> data) {
    data["id"] = data["_id"];
    return _$UserFavouriteDatasetFromJson(data);
  }

  Map<String, dynamic> toJson() => _$UserFavouriteDatasetToJson(this);
}
