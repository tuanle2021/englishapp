import 'package:flutter/material.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/common/nagivation_service.dart';
import 'package:learning_english_app/common/controller/social_login_controller.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/login/models/dao/token_dao.dart';
import 'package:learning_english_app/profile/models/dao/setting_dao.dart';
import 'package:learning_english_app/profile/models/dao/userprofile_dao.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';

class FacebookuserService {
  TokenDao? _tokenDao;
  UserProfileDao? _userProfileDao;

  HttpClientService _httpClientService = new HttpClientService();
  UserProfileDataset userProfile = UserProfileDataset(id: "0");

  void getListFacebookUser(String? userId, VoidCallback? success(Object result),
      VoidCallback? failure(error)) {
    _tokenDao = StorageController.database!.tokenDao;
    var url = Environment.apiUrl +
        '/facebook-token/${AppInfo.apiVersion}/friend-score';
    Map<String, dynamic> parameter = Map<String, dynamic>();
    parameter["id"] = userId;
    _httpClientService.requestTo(
        url: url,
        method: HttpMethod.GET,
        parameters: parameter,
        success: success,
        failure: failure);
  }
}

class FacebookUser {
  final String name;
  final String imageUrl;
  final int point;

  const FacebookUser({
    required this.name,
    required this.imageUrl,
    required this.point,
  });
  factory FacebookUser.fromJson(Map<String, dynamic> json) {
    return FacebookUser(
      name: json['name'],
      imageUrl: json['imageUrl'],
      point: json['point'],
    );
  }
}

class ListFacebookUser {
  final List<FacebookUser> facebook_friends;

  const ListFacebookUser({
    required this.facebook_friends,
  });

  factory ListFacebookUser.fromJson(List<dynamic> json_list) {
    List<FacebookUser> ListFacebookUser_factory = <FacebookUser>[];
    json_list.forEach((item) {
      ListFacebookUser_factory.add(FacebookUser.fromJson(item));
    });
    return ListFacebookUser(facebook_friends: ListFacebookUser_factory);
  }
}
