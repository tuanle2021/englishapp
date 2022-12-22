import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';

part 'user_card_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'USER_CARD')
class UserCardDataset {
  UserCardDataset(
      {this.id,
      this.created_at,
      this.catId,
      this.wordId,
      this.due,
      this.ease,
      this.interval,
      this.isDeleted,
      this.original_interval,
      this.phase,
      this.step,
      this.updated_at,
      this.userId});

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "wordId")
  String? wordId;

  @ColumnInfo(name: "catId")
  String? catId;

  @ColumnInfo(name: "userId")
  String? userId;

  @ColumnInfo(name: "phase")
  int? phase;

  @ColumnInfo(name: "interval")
  double? interval;

  @ColumnInfo(name: "originInterval")
  double? original_interval;

  @ColumnInfo(name: "ease")
  double? ease;

  @ColumnInfo(name: "due")
  double? due;

  @ColumnInfo(name: "step")
  double? step;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  @ignore
  @JsonKey(ignore: true)
  WordDataset? word;

  factory UserCardDataset.fromJson(Map<String, dynamic> data) {
    data["id"] = data["_id"];
    return _$UserCardDatasetFromJson(data);
  }

  Map<String, dynamic> toJson() => _$UserCardDatasetToJson(this);
}
