import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_user_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'CATEGORY_USER')
class CategoryUserDataset {
  CategoryUserDataset(
      {required this.id,
      this.categoryId,
      this.isDeleted,
      this.progress,
      this.userId});

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String id;

  @ColumnInfo(name: "userId")
  String? userId;

  @ColumnInfo(name: "categoryId")
  String? categoryId;

  @ColumnInfo(name: "progress")
  int? progress;

  @ColumnInfo(name: "isDeleted")
  bool? isDeleted;

  @ColumnInfo(name: "updated_at")
  String? updated_at;

  @ColumnInfo(name: "created_at")
  String? created_at;

  

  factory CategoryUserDataset.fromJson(Map<String, dynamic> data) =>
      _$CategoryUserDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$CategoryUserDatasetToJson(this);
}
