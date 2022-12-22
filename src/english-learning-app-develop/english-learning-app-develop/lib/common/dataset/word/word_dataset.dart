import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';
part 'word_dataset.g.dart';

@JsonSerializable()
@Entity(tableName: 'WORD')
class WordDataset {
  WordDataset(
      this.id,
      this.word_id,
      this.word,
      this.lexicalCategory,
      this.type,
      this.ori_lang,
      this.tra_lang,
      this.definitions,
      this.shortDefinitions,
      this.examples,
      this.phoneticNotation,
      this.phoneticSpelling,
      this.audioFile,
      this.synonyms,
      this.phrases,
      this.mean,
      this.category,
      this.level);

  @PrimaryKey()
  @ColumnInfo(name: "id")
  String? id;

  @ColumnInfo(name: "wordId")
  String? word_id;

  @ColumnInfo(name: "word")
  String? word;

  @ColumnInfo(name: "lexicalCategory")
  String? lexicalCategory;

  @ColumnInfo(name: "type")
  String? type;

  @ColumnInfo(name: "ori_lang")
  String? ori_lang;

  @ColumnInfo(name: "tra_lang")
  String? tra_lang;

  @ColumnInfo(name: "definitions")
  String? definitions;

  @ColumnInfo(name: "shortDefinitions")
  String? shortDefinitions;

  @ColumnInfo(name: "examples")
  String? examples;

  @ColumnInfo(name: "phoneticNotation")
  String? phoneticNotation;

  @ColumnInfo(name: "phoneticSpelling")
  String? phoneticSpelling;

  @ColumnInfo(name: "audioFile")
  String? audioFile;

  @ColumnInfo(name: "synonyms")
  String? synonyms;

  @ColumnInfo(name: "phrases")
  String? phrases;

  @ColumnInfo(name: "mean")
  String? mean;

  @ColumnInfo(name: "category")
  String? category;

  @ColumnInfo(name: "level")
  String? level;

  @ColumnInfo(name: "image")
  String? image;

  factory WordDataset.fromJson(Map<String, dynamic> data) =>
      _$WordDatasetFromJson(data);
  Map<String, dynamic> toJson() => _$WordDatasetToJson(this);
}
