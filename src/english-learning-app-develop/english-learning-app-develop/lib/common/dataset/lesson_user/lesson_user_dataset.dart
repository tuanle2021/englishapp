import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lesson_user_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'LESSON_USER')
class LessonUserDataset {
  LessonUserDataset({
    required this.id,
    this.isBlock,
    this.isCompleted,
    this.userId,
    this.lessonId,
  });

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String id;

  @ColumnInfo(name: "lessonId")
  String? lessonId;

  @ColumnInfo(name: "userId")
  String? userId;

  @ColumnInfo(name: "isBlock")
  bool? isBlock;

  @ColumnInfo(name: "isCompleted")
  bool? isCompleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  factory LessonUserDataset.fromJson(Map<String, dynamic> data) {
    data["id"] = data["_id"];
    return _$LessonUserDatasetFromJson(data);
  }

  Map<String, dynamic> toJson() => _$LessonUserDatasetToJson(this);
}
