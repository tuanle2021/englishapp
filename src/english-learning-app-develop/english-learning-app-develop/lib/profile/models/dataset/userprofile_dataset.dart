import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning_english_app/common/leareng_log.dart';

part 'userprofile_dataset.g.dart';

@Entity(tableName: "USER")
@JsonSerializable()
class UserProfileDataset {
  UserProfileDataset(
      {this.firstName,
      this.lastName,
      this.authStrategy,
      this.createdTime,
      this.deviceId,
      this.email,
      this.facebookId,
      this.googleId,
      this.isActivated,
      this.isActive,
      this.isSharedData,
      this.isLock,
      this.otpNumber,
      this.photoUrl,
      this.mainAuthStrategy,
      required this.id});

  @JsonKey(defaultValue: null)
  @ColumnInfo(name: 'first_name')
  String? firstName;

  @JsonKey(defaultValue: null)
  @ColumnInfo(name: 'last_name')
  String? lastName;

  @ColumnInfo(name: 'auth_strategy')
  @JsonKey(defaultValue: null)
  String? authStrategy;

  @ColumnInfo(name: 'email')
  @JsonKey(defaultValue: null)
  String? email;

  @ColumnInfo(name: 'device_id')
  @JsonKey(ignore: true)
  String? deviceIdString;

  @ignore
  @JsonKey(defaultValue: null)
  List<String?>? deviceId;

  @ColumnInfo(name: 'google_id')
  @JsonKey(defaultValue: null)
  String? googleId;

  @ColumnInfo(name: 'facebook_id')
  @JsonKey(defaultValue: null)
  String? facebookId;

  @ColumnInfo(name: 'otp_number')
  @JsonKey(defaultValue: null)
  String? otpNumber;

  @ColumnInfo(name: 'isActive')
  @JsonKey(defaultValue: null)
  bool? isActive;

  @ColumnInfo(name: 'isSharedData')
  @JsonKey(defaultValue: null)
  bool? isSharedData;

  @ColumnInfo(name: 'isLock')
  @JsonKey(defaultValue: null)
  bool? isLock;

  @ColumnInfo(name: 'isActivated')
  @JsonKey(defaultValue: null)
  bool? isActivated;

  @ColumnInfo(name: 'created_time')
  @JsonKey(defaultValue: null)
  String? createdTime;

  @PrimaryKey()
  @ColumnInfo(name: 'id')
  @JsonKey(required: true)
  String? id;

  @ColumnInfo(name: 'photo_url')
  @JsonKey(defaultValue: "")
  String? photoUrl;

  @ColumnInfo(name: 'main_auth_strategy')
  @JsonKey(defaultValue: "local")
  String? mainAuthStrategy;

  factory UserProfileDataset.fromJson(Map<String, dynamic> data) {
    var userProfile = _$UserProfileDatasetFromJson(data);
    userProfile.deviceIdString = userProfile.deviceId?.join(",");
    return userProfile;
  }

  Map<String, dynamic> toJson() => _$UserProfileDatasetToJson(this);
}
