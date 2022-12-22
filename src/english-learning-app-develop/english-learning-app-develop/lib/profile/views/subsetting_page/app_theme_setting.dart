import 'package:flutter/material.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/main.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';

class SettingAppThemePage extends StatefulWidget {
  final ProfileService? service;
  SettingAppThemePage({required this.service});

  @override
  State<SettingAppThemePage> createState() => _SettingAppThemePageState();
}

class _SettingAppThemePageState extends State<SettingAppThemePage> {
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
        appBar: CustomAppBar(AppLocalizations.of(context).appTheme)
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
                          MyApp.setThemeMode(context,ThemeMode.light);
                          setState(() {
                            service.userSetting!.themeMode =
                                ThemeSetting.Light.name;
                            service.updateSetting();
                          });
                        },
                        child: ListTile(
                          title: Text(AppLocalizations.of(context).lightmode),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          horizontalTitleGap: 0,
                          trailing: (service.userSetting != null &&
                                  service.userSetting!.themeMode ==
                                      ThemeSetting.Light.name)
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
                          MyApp.setThemeMode(context,ThemeMode.dark);
                          setState(() {
                            service.userSetting!.themeMode =
                                ThemeSetting.Dark.name;
                            service.updateSetting();
                          });
                        },
                        child: ListTile(
                          title: Text(AppLocalizations.of(context).darkmode),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          horizontalTitleGap: 0,
                          trailing: (service.userSetting != null &&
                                  service.userSetting!.themeMode == ThemeSetting.Dark.name)
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
                          MyApp.setThemeMode(context,ThemeMode.system);
                          setState(() {
                            service.userSetting!.themeMode =
                                ThemeSetting.System.name;
                            service.updateSetting();
                          });
                        },
                        child: ListTile(
                          title: Text(AppLocalizations.of(context).system),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          horizontalTitleGap: 0,
                          trailing: (service.userSetting != null &&
                                  service.userSetting!.themeMode == ThemeSetting.System.name)
                              ? Icon(Icons.check,color: Theme.of(context).colorScheme.onBackground)
                              : null,
                        ),
                      ),
                    ]),
                  )),
            ],
          ),
        ));
  }
}
