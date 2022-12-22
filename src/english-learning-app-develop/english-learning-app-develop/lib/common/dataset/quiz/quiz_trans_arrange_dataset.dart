import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';

part 'quiz_trans_arrange_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'QUIZ_TRANS_ARRANGE')
class QuizTransArrangeDataset extends QuizExtend {
  QuizTransArrangeDataset(
      {this.id,
      this.created_at,
      this.lessonId,
      this.wordId,
      this.type,
      this.updated_at,
      this.isDeleted,
      this.name,
      this.originSentence,
      this.viSentence,
      this.numRightPhrase,
      this.viPhrase});

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

  @ColumnInfo(name: "origin_sentence")
  String? originSentence;

  @ColumnInfo(name: "vi_sentence")
  String? viSentence;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  @ColumnInfo(name: "numRightPhrase")
  int? numRightPhrase;

  @ignore
  List<String>? viPhrase;

  factory QuizTransArrangeDataset.fromJson(Map<String, dynamic> data) =>
      _$QuizTransArrangeDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$QuizTransArrangeDatasetToJson(this);
}
