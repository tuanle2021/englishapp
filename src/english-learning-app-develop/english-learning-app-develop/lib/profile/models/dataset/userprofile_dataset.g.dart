// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userprofile_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileDataset _$UserProfileDatasetFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return UserProfileDataset(
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    authStrategy: json['authStrategy'] as String?,
    createdTime: json['createdTime'] as String?,
    deviceId:
        (json['deviceId'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    email: json['email'] as String?,
    facebookId: json['facebookId'] as String?,
    googleId: json['googleId'] as String?,
    isActivated: json['isActivated'] as bool?,
    isActive: json['isActive'] as bool?,
    isSharedData: json['isSharedData'] as bool?,
    isLock: json['isLock'] as bool?,
    otpNumber: json['otpNumber'] as String?,
    photoUrl: json['photoUrl'] as String? ?? '',
    mainAuthStrategy: json['mainAuthStrategy'] as String? ?? 'local',
    id: json['id'] as String?,
  );
}

Map<String, dynamic> _$UserProfileDatasetToJson(UserProfileDataset instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'authStrategy': instance.authStrategy,
      'email': instance.email,
      'deviceId': instance.deviceId,
      'googleId': instance.googleId,
      'facebookId': instance.facebookId,
      'otpNumber': instance.otpNumber,
      'isActive': instance.isActive,
      'isSharedData': instance.isSharedData,
      'isLock': instance.isLock,
      'isActivated': instance.isActivated,
      'createdTime': instance.createdTime,
      'id': instance.id,
      'photoUrl': instance.photoUrl,
      'mainAuthStrategy': instance.mainAuthStrategy,
    };
