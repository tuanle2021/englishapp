import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var service = ProfileService();
  String valueThemeMode = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service.getUserSetting().then((value) {
      setState(() {
        if (value!.themeMode == ThemeSetting.Light.name) {
          valueThemeMode = AppLocalizations.of(context).lightmode;
        } else if (value!.themeMode == ThemeSetting.Dark.name) {
          valueThemeMode = AppLocalizations.of(context).darkmode;
        } else {
          valueThemeMode = AppLocalizations.of(context).system;
        }

        service.userSetting = value;
      });
    });
  }
  String getThemeMode() {
    if (service.userSetting != null) {
        if (service.userSetting!.themeMode == ThemeSetting.Light.name) {
          valueThemeMode = AppLocalizations.of(context).lightmode;
        } else if (service.userSetting!.themeMode == ThemeSetting.Dark.name) {
          valueThemeMode = AppLocalizations.of(context).darkmode;
        } else {
          valueThemeMode = AppLocalizations.of(context).system;
        }
      }
      return valueThemeMode;
    }
   
     
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(AppLocalizations.of(context).general)
          .customAppBar(context),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: SettingsList(
            darkTheme: SettingsThemeData(
                settingsListBackground:
                    Theme.of(context).colorScheme.background),
            sections: [
              SettingsSection(
                margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                tiles: [
                  SettingsTile(
                    title: Text(AppLocalizations.of(context).appLanguage),
                    value: Text((service.userSetting != null)
                        ? service.userSetting!.appLanguage
                        : ""),
                    leading: Icon(Icons.language),
                    onPressed: (BuildContext context) {
                      return Navigator.of(context).pushNamed(
                          '/app_language_setting',
                          arguments: service);
                    },
                  ),
                  SettingsTile(
                    title: Text(AppLocalizations.of(context).appTheme),
                    leading: (Theme.of(context).brightness == Brightness.light) ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
                    value: Text(getThemeMode()),
                    onPressed: (BuildContext context) {
                      if (service.userSetting != null) {
                        return Navigator.of(context).pushNamed(
                            '/app_theme_setting',
                            arguments: service);
                      }
                    },
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
