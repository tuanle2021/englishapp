import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:learning_english_app/login/models/dao/token_dao.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/dialog_controller.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  var service = ProfileService();
  String valueThemeMode = "";
  TokenDao? _tokenDao;
  HttpClientService _httpClientService = new HttpClientService();
  final textContentController = TextEditingController();

  bool isSendData = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void SubmitFeedBack() {
    _tokenDao = StorageController.database!.tokenDao;
    var url = Environment.apiUrl + '/feedback/${AppInfo.apiVersion}/';
    Map<String, dynamic> parameter = Map<String, dynamic>();
    parameter["content"] = textContentController.text;
    _httpClientService.requestTo(
        url: url,
        method: HttpMethod.POST,
        parameters: parameter,
        success: (success) {
          // show dialog success and set text by null
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('Thanks for your feedbacks'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
          //
          textContentController.clear();
        },
        failure: (error) {});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(AppLocalizations.of(context).feedback)
            .customAppBar(context),
        body: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                Card(
                    child: TextField(
                  controller: textContentController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText:
                        "Please briefly describe the issue of english learning app",
                    hintStyle: TextStyle(
                      fontSize: 13.0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 45, 41, 41),
                      ),
                    ),
                  ),
                )),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 20, 120, 137),
                  ),
                  onPressed: SubmitFeedBack,
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: Color.fromARGB(255, 248, 248, 248),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )));
  }
}
