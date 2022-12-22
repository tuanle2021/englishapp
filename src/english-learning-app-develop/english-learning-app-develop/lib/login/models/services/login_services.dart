import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/environment.dart';

class LoginService {
  final httpClientService = HttpClientService();
  Map<String, dynamic> makeUserDataset(
      String email, String firstName, String lastName, String plainPassword) {
    var user = new Map<String, dynamic>();
    user["username"] = email;
    user["email"] = email;
    user["plainPassword"] = plainPassword;
    user["firstName"] = firstName;
    user["lastName"] = lastName;
    return user;
  }

  void signUp(
      String email,
      String firstName,
      String lastName,
      String plainPassword,
      VoidCallback? success(Object result),
      VoidCallback? failure(Object error)) {
    var url = Environment.apiUrl + '/auth/${AppInfo.apiVersion}/signup';
    var user = makeUserDataset(email, firstName, lastName, plainPassword);
    httpClientService.requestTo(
        url: url,
        method: HttpMethod.POST,
        parameters: user,
        success: success,
        failure: failure);
  }

  void forgotPassword(
      String email,
      VoidCallback? success(Object result),
      VoidCallback? failure(Object error)) {
    var url = Environment.apiUrl +
        '/user/${AppInfo.apiVersion}/gen-reset-link/${email}';
    httpClientService.requestTo(
        url: url, method: HttpMethod.GET, success: success, failure: failure);
  }

  void signIn(
      String email,
      String password,
      VoidCallback? success(Object result),
      VoidCallback? failure(Object error)) {
    var url = Environment.apiUrl + '/auth/${AppInfo.apiVersion}/login';
    Map<String, dynamic> loginDataset = new Map();
    loginDataset["username"] = email;
    loginDataset["password"] = password;
    loginDataset["device_id"] = DeviceInfo.deviceID;

    httpClientService.requestTo(
        url: url,
        method: HttpMethod.POST,
        parameters: loginDataset,
        success: success,
        failure: failure,
        isLoginApi: true);
  }

  void signInWithFaceBook({
    required String accessToken,
    required void Function()? success(Object result),
    required void Function()? failure(Object error),
  }) {
    var url = Environment.apiUrl + '/auth/${AppInfo.apiVersion}/facebook-token';
    Map<String, dynamic> parameter = new Map();
    parameter["access_token"] = accessToken;
    parameter["device_id"] = DeviceInfo.deviceID;
    httpClientService.requestTo(
        url: url,
        method: HttpMethod.POST,
        parameters: parameter,
        success: success,
        failure: failure,
        isLoginApi: true);
  }

  void signInWithGoogle(
      {required String accessToken,
      required void Function()? success(Object result),
      required void Function()? failure(Object error)}) {
    var url = Environment.apiUrl + '/auth/${AppInfo.apiVersion}/google-token';
    Map<String, dynamic> parameter = new Map();
    parameter["access_token"] = accessToken;
    parameter["device_id"] = DeviceInfo.deviceID;
    httpClientService.requestTo(
        url: url,
        method: HttpMethod.POST,
        parameters: parameter,
        success: success,
        failure: failure,
        isLoginApi: true);
  }

  void sendActivateCode(
      String email,
      String password,
      VoidCallback? success(Object result),
      VoidCallback? failure(Object error)) {
    var url =
        Environment.apiUrl + '/auth/${AppInfo.apiVersion}/sendActivationCode';
    Map<String, dynamic> loginDataset = new Map();
    loginDataset["username"] = email;
    loginDataset["password"] = password;
    loginDataset["email"] = email;
    httpClientService.requestTo(
        url: url,
        method: HttpMethod.POST,
        parameters: loginDataset,
        success: success,
        failure: failure);
  }

  void veriyActivateCode({
    required String code,
    required String email,
    required String password,
    required void Function()? success(Object result),
    required void Function()? failure(Object error),
  }) {
    var httpClient = HttpClientService();
    var url =
        Environment.apiUrl + '/auth/${AppInfo.apiVersion}/verifyActivationCode';
    Map<String, dynamic> loginDataset = new Map();
    loginDataset["username"] = email;
    loginDataset["password"] = password;
    loginDataset["code"] = code;
    httpClient.requestTo(
        url: url,
        method: HttpMethod.POST,
        parameters: loginDataset,
        success: success,
        failure: failure);
  }
}
