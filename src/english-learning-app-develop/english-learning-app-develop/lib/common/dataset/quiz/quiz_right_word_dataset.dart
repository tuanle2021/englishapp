
import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';

part 'quiz_right_word_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'QUIZ_RIGHT_WORD')
class QuizRightWordDataset extends QuizExtend {
  QuizRightWordDataset({
    this.id,
    this.created_at,
    this.lessonId,
    this.wordId,
    this.type,
    this.updated_at,
    this.isDeleted,
    this.correctChoice,
    this.firstChoice,
    this.name,
    this.secondChoice,
    this.thirdChoice,
  });

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "name")
  String? name;

  @ColumnInfo(name: "lessonId")
  String? lessonId;

  @ColumnInfo(name: "type")
  String? type;

  @ColumnInfo(name: "wordId")
  String? wordId;

  @ColumnInfo(name: "correctChoice")
  String? correctChoice;

  @ColumnInfo(name: "firstChoice")
  String? firstChoice;

  @ColumnInfo(name: "secondChoice")
  String? secondChoice;

  @ColumnInfo(name: "thirdChoice")
  String? thirdChoice;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  factory QuizRightWordDataset.fromJson(Map<String, dynamic> data) =>
      _$QuizRightWordDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$QuizRightWordDatasetToJson(this);
}
