import 'package:floor/floor.dart';

@Entity(tableName: 'TOKEN')
class TokenDataset {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'device_id')
  final String deviceId;

  @ColumnInfo(name: 'token')
  final String token;

  @ColumnInfo(name: 'expiry_date')
  final String expiryDate;

  @ColumnInfo(name: 'type')
  final String tokenType;

  TokenDataset({
    this.id, required this.deviceId, required this.token, required this.expiryDate, required this.tokenType
  }
);
}
