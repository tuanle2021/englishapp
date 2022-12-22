import 'package:floor/floor.dart';

@Entity(tableName: 'VI_PHRASE')
class ViPhraseDataset {
  

  @PrimaryKey(autoGenerate: true)
  int? id;

  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: "quiz_id")
  String? quizId;

  @ColumnInfo(name: "viPhrase")
  String? viPhrase;

  ViPhraseDataset({this.quizId, this.viPhrase,this.id});
}
