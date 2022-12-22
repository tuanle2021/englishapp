import 'package:floor/floor.dart';
import 'dart:convert';

enum Language {
  VN,
  EN,
}

enum ThemeSetting { Light, Dark, System }

@Entity(tableName: 'SETTING')
class SettingDataset {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'device_id')
  String deviceId;

  @ColumnInfo(name: 'app_language')
  String appLanguage;

  @ColumnInfo(name: 'theme_mode')
  String themeMode;

  @ColumnInfo(name: 'notificationPermit')
  bool notificationPermit = false;

  @ColumnInfo(name: 'dayInWeek')
  String dayInWeek = "";

  @ColumnInfo(name: 'notiTime')
  String notiTime = "";

  SettingDataset(
    this.appLanguage,
    this.themeMode, {
    this.id,
    this.dayInWeek = "",
    this.notiTime = "",
    this.notificationPermit = false,
    required this.deviceId,
  });

  @override
  String toString() {
    Map<String, String> map = new Map();
    map["device_id"] = deviceId;
    map["app_language"] = appLanguage;
    map["theme_mode"] = themeMode;
    return json.encode(map);
  }
}
