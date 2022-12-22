import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';

part 'lesson_user_score_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'LESSON_USER_SCORE')
class LessonUserScoreDataset {
  LessonUserScoreDataset(
      {required this.id,
      required this.lessonId,
      required this.userId,
      this.completedAt,
      this.completionTime,
      this.point,
      this.accuracy,
      this.totalCorrect,
      this.totalIncorrect});

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String id;

  @ColumnInfo(name: "totalIncorrect")
  int? totalIncorrect;

  @ColumnInfo(name: "totalCorrect")
  int? totalCorrect;

  @ColumnInfo(name: "point")
  int? point;

  @ColumnInfo(name: "completionTime")
  String? completionTime;

  @ColumnInfo(name: "completedAt")
  String? completedAt;

  @ColumnInfo(name: "accuracy")
  double? accuracy;

  @ColumnInfo(name: "userId")
  String userId;

  @ColumnInfo(name: "lessonId")
  String lessonId;

  @ignore
  @JsonKey(ignore: true)
  LessonDataset? lessonDataset;

  factory LessonUserScoreDataset.fromJson(Map<String, dynamic> data) {
    data["id"] = data["_id"];
    return _$LessonUserScoreDatasetFromJson(data);
  }

  Map<String, dynamic> toJson() => _$LessonUserScoreDatasetToJson(this);
}
