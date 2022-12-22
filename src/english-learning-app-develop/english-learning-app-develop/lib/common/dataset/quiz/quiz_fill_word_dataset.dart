import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';

part 'quiz_fill_word_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'QUIZ_FILL_WORD')
class QuizFillWordDataset extends QuizExtend {
  QuizFillWordDataset({
    this.id,
    this.created_at,
    this.lessonId,
    this.wordId,
    this.type,
    this.updated_at,
    this.isDeleted,
    this.correctChoice,
    this.firstChoice,
    this.leftOfWord,
    this.name,
    this.rightOfWord,
    this.secondChoice,
    this.thirdChoice,
    this.viSentence
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

  @ColumnInfo(name: "left_of_word")
  String? leftOfWord;

  @ColumnInfo(name: "right_of_word")
  String? rightOfWord;

  @ColumnInfo(name: "vi_sentence")
  String? viSentence;

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

  factory QuizFillWordDataset.fromJson(Map<String, dynamic> data) =>
      _$QuizFillWordDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$QuizFillWordDatasetToJson(this);
}
