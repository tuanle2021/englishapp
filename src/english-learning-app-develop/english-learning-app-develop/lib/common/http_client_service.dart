import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/common/nagivation_service.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/login/models/dataset/token_dataset.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants.dart';

enum HttpMethod {
  POST,
  GET,
  PUT,
  DELETE,
  HEAD,
}

class HttpClientService {
  String? accessToken = "";

  var dio = Dio();
  var tokenDao = StorageController.database?.tokenDao;
  static int retryRefreshToken = 0;
  static final Connectivity connectivity = Connectivity();
  static bool isHasInternetConnection = false;

  Future<void> requestTo(
      {required String url,
      required HttpMethod method,
      Map<String, dynamic>? parameters,
      required void Function()? success(Object result),
      required void Function()? failure(Object error),
      bool isLoginApi = false}) async {
    dio.options.connectTimeout = 60 * 100000;
    dio.options.receiveTimeout = 60 * 100000;
    dio.options.receiveDataWhenStatusError = true;

    accessToken =
        (await tokenDao?.getRefreshToken("ACCESS_TOKEN").first)?.token;

    Map<String, dynamic> logParam = Map();
    logParam["Url"] = url;
    logParam["method"] = method.toString();
    logParam["parameters"] = parameters.toString();

    LearnEngLog.logger.i(logParam);

    //Check internet connection
    if (isHasInternetConnection == false) {
      Map<String, dynamic> error = Map();
      error["error"] =
          AppLocalizations.of(NavigationService.navigatorKey!.currentContext!)
              .noInternetConnection;
      error["isNotHasInternet"] = true;
      failure(error);
      return;
    }
    if (isLoginApi == false) {
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        options.headers['content-Type'] = 'application/json';
        if (accessToken != null && accessToken != '')
          options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      }, onError: (DioError e, handler) async {
        if (retryRefreshToken == 2) {
          retryRefreshToken = 0;
          handler.next(e);
          NavigationService.navigatorKey.currentState!
              .pushNamedAndRemoveUntil('/introduce', (route) => false);
          tokenDao?.deleteRToken("REFRESH_TOKEN");
          tokenDao?.deleteRToken("ACCESS_TOKEN");
          ToastController.showInfo(
              AppLocalizations.of(
                      NavigationService.navigatorKey.currentContext!)
                  .loginSessionExpired,
              NavigationService.navigatorKey.currentContext);
          return;
        }
        if (e.response?.statusCode == 401) {
          retryRefreshToken = retryRefreshToken + 1;
          // refresh token here
          var refreshTokenUrl = Environment.apiUrl + '/auth/v1/refreshtoken';

          var refreshToken =
              await tokenDao?.getRefreshToken("REFRESH_TOKEN").first;
          var parameters = {'refreshToken': refreshToken?.token};
          await dio.post(refreshTokenUrl, data: parameters).then((value) async {
            if (value.statusCode == 201 || value.statusCode == 200) {
              var resultMap = value.data as Map<String, dynamic>;
              DeviceInfo.getDeviceId().then((deviceId) async {
                tokenDao?.deleteRToken("REFRESH_TOKEN");
                tokenDao?.deleteRToken("ACCESS_TOKEN");
                var accessToken = new TokenDataset(
                    deviceId: deviceId!,
                    token: resultMap["accessToken"] as String,
                    expiryDate: "",
                    tokenType: "ACCESS_TOKEN");
                tokenDao?.insertToken(accessToken);
                var refreshTokenData =
                    resultMap["refreshToken"] as Map<String, dynamic>;
                var refreshToken = new TokenDataset(
                    deviceId: deviceId,
                    token: refreshTokenData["refreshToken"] as String,
                    expiryDate: refreshTokenData["expiry"].toString(),
                    tokenType: "REFRESH_TOKEN");
                tokenDao?.insertToken(refreshToken);
                e.requestOptions.headers["Authorization"] =
                    "Bearer " + resultMap["accessToken"];
                //create request with new access token
                final opts = new Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers);
                final response = await dio.request(e.requestOptions.path,
                    options: opts,
                    data: e.requestOptions.data,
                    queryParameters: e.requestOptions.queryParameters);
                switch (method) {
                  case HttpMethod.POST:
                    {
                      try {
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          LearnEngLog.logger.i(response.toString());
                          success(response.data);
                        } else {
                          failure(response.data);
                        }
                      } on DioError catch (ex) {
                        LearnEngLog.logger.e(ex.toString());
                        if (ex.type == DioErrorType.connectTimeout) {
                          var error = new Map<String, dynamic>();
                          error["error"] = AppLocalizations.of(NavigationService
                                  .navigatorKey!.currentContext!)
                              .connectionTimeout;
                          failure(error);
                        } else if (ex.type == DioErrorType.response) {
                          failure(ex.response?.data);
                        }
                        var error = new Map<String, dynamic>();
                        error["error"] = AppLocalizations.of(
                                NavigationService.navigatorKey!.currentContext!)
                            .somethingwentwrongpleasetryagainlater;
                        failure(error);
                      }
                      break;
                    }
                  case HttpMethod.GET:
                    try {
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        LearnEngLog.logger.i(response.toString());
                        success(response.data);
                      } else {
                        failure(response.data);
                      }
                    } on DioError catch (ex) {
                      LearnEngLog.logger.e(ex);
                      if (ex.type == DioErrorType.connectTimeout) {
                        var error = new Map<String, dynamic>();
                        error["error"] = AppLocalizations.of(
                                NavigationService.navigatorKey!.currentContext!)
                            .connectionTimeout;
                        failure(error);
                      } else if (ex.type == DioErrorType.response) {
                        failure(ex.response?.data);
                      }
                      var error = new Map<String, dynamic>();
                      error["error"] = AppLocalizations.of(
                              NavigationService.navigatorKey!.currentContext!)
                          .somethingwentwrongpleasetryagainlater;
                      failure(error);
                    }
                    break;
                  case HttpMethod.PUT:
                    // TODO: Handle this case.
                    break;
                  case HttpMethod.DELETE:
                    // TODO: Handle this case.
                    break;
                  case HttpMethod.HEAD:
                    // TODO: Handle this case.
                    break;
                }
                //return handler.resolve(response);
              });
            }
          });
        }
        // Do something with response error
        return handler.next(e); //continue
        // If you want to resolve the request with some custom data，
        // you can resolve a `Response` object eg: `handler.resolve(response)`.
      }));
    } else {}

    switch (method) {
      case HttpMethod.POST:
        {
          try {
            var response = await dio.post(url, data: parameters);
            if (response.statusCode == 200 || response.statusCode == 201) {
              LearnEngLog.logger.i(response);
              success(response.data);
            } else {
              failure(response.data);
            }
          } on DioError catch (ex) {
            LearnEngLog.logger.e(ex);

            if (ex.type == DioErrorType.connectTimeout) {
              var error = new Map<String, dynamic>();
              error["error"] = AppLocalizations.of(
                      NavigationService.navigatorKey!.currentContext!)
                  .connectionTimeout;
              failure(error);
            } else if (ex.type == DioErrorType.response) {
              if (ex.response?.statusCode == 401 && isLoginApi == true) {
                var error = new Map<String, dynamic>();
                error["error"] = AppLocalizations.of(
                        NavigationService.navigatorKey!.currentContext!)
                    .invalidCredentialLoginError;
                failure(error);
                return;
              }
              failure(ex.response?.data);
            }
            var error = new Map<String, dynamic>();
            error["error"] = AppLocalizations.of(
                    NavigationService.navigatorKey!.currentContext!)
                .somethingwentwrongpleasetryagainlater;
            failure(error);
          }
          break;
        }
      case HttpMethod.GET:
        try {
          var response = await dio.get(url);
          if (response.statusCode == 200 || response.statusCode == 201) {
            LearnEngLog.logger.i(response);
            success(response.data);
          } else {
            failure(response.data);
          }
        } on DioError catch (ex) {
          ;
          if (ex.type == DioErrorType.connectTimeout) {
            var error = new Map<String, dynamic>();
            error["error"] = AppLocalizations.of(
                    NavigationService.navigatorKey!.currentContext!)
                .connectionTimeout;
            failure(error);
          } else if (ex.type == DioErrorType.response) {
            failure(ex.response?.data);
          }
          LearnEngLog.logger.e(ex.type);
            LearnEngLog.logger.e(url);

          var error = new Map<String, dynamic>();
          error["error"] = AppLocalizations.of(
                  NavigationService.navigatorKey!.currentContext!)
              .somethingwentwrongpleasetryagainlater;
          failure(error);
        }
        break;
      case HttpMethod.PUT:
        // TODO: Handle this case.
        break;
      case HttpMethod.DELETE:
        // TODO: Handle this case.
        break;
      case HttpMethod.HEAD:
        // TODO: Handle this case.
        break;
    }
  }
}
