import 'package:flutter/material.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/main.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';

class SettingAppLanguagePage extends StatefulWidget {
  final ProfileService? service;
  SettingAppLanguagePage({required this.service});

  @override
  State<SettingAppLanguagePage> createState() => _SettingAppLanguagePageState();
}

class _SettingAppLanguagePageState extends State<SettingAppLanguagePage> {
  var service = ProfileService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service = widget.service!;
    service.getUserSetting().then((value) {
      setState(() {
        service.userSetting = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(AppLocalizations.of(context).appLanguage)
            .customAppBar(context),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(
                      top: 40.0, left: 15.0, right: 15.0, bottom: 10.0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 5.0,
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(children: [
                      InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        splashColor:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                        onTap: () {
                          Locale newLocale = Locale('en', '');
                          MyApp.setLocale(context, newLocale);
                          setState(() {
                            service.userSetting!.appLanguage = Language.EN.name;
                            service.updateSetting();
                          });
                        },
                        child: ListTile(
                          title: Text(
                              AppLocalizations.of(context).englishLanguage),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          horizontalTitleGap: 0,
                          trailing: (service.userSetting != null &&
                                  service.userSetting!.appLanguage ==
                                      Language.EN.name)
                              ? Icon(Icons.check,color: Theme.of(context).colorScheme.onBackground)
                              : null,
                        ),
                      ),
                      Divider(
                        height: 0,
                        indent: 0,
                      ),
                      InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        splashColor:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                        onTap: () {
                          Locale newLocale = Locale('vi', '');
                          MyApp.setLocale(context, newLocale);
                          setState(() {
                            service.userSetting!.appLanguage = Language.VN.name;
                            service.updateSetting();
                          });
                        },
                        child: ListTile(
                          title: Text(
                              AppLocalizations.of(context).vietnameseLanguage),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          horizontalTitleGap: 0,
                          trailing: (service.userSetting != null &&
                                  service.userSetting!.appLanguage ==
                                      Language.VN.name)
                              ? Icon(Icons.check,color: Theme.of(context).colorScheme.onBackground)
                              : null,
                        ),
                      )
                    ]),
                  )),
            ],
          ),
        ));
  }
}
