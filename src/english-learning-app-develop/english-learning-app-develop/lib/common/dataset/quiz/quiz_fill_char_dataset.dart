import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';

part 'quiz_fill_char_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'QUIZ_FILL_CHAR')
class QuizFillCharDataset extends QuizExtend {
  QuizFillCharDataset({
    this.id,
    this.created_at,
    this.lessonId,
    this.wordId,
    this.type,
    this.updated_at,
    this.isDeleted,
    this.name,
  });

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "name")
  String? name;

  @ColumnInfo(name: "type")
  String? type;

  @ColumnInfo(name: "lessonId")
  String? lessonId;

  @ColumnInfo(name: "wordId")
  String? wordId;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  

  factory QuizFillCharDataset.fromJson(Map<String, dynamic> data) =>
      _$QuizFillCharDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$QuizFillCharDatasetToJson(this);
}
