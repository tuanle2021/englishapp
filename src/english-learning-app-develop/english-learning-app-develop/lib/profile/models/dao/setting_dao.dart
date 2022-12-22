
import 'package:floor/floor.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';

@dao
abstract class SettingDao {
  @Query('SELECT * FROM SETTING WHERE device_id = :deviceId')
  Future<SettingDataset?> findSetting(String deviceId);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateSetting(SettingDataset settingEntity);

  @insert
  Future<int> insertSetting(SettingDataset settingEntity);
}