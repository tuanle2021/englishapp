import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/environment.dart';

class WordService {
  HttpClientService httpClientService = HttpClientService();
  void getAllWord({
    required void Function()? success(Object result),
    required void Function()? failure(Object error),
  }) {
    var url = Environment.apiUrl + '/word/${AppInfo.appVersion}/getAllWord';
    httpClientService.requestTo(url: url,method: HttpMethod.GET,parameters: null,success: success, failure:failure);
  }
}
