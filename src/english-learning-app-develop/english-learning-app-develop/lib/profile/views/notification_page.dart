import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/dialog_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/controller/notification_controller.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/login_button.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TimeOfDay? notificationTime = null;
  List<bool> dayUserChoose = List.generate(7, (index) => false);
  final RoundedLoadingButtonController roundedLoadingButtonController =
      RoundedLoadingButtonController();

  final ProfileService profileService = ProfileService();
  SettingDataset? settingDataset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileService.getUserSetting().then((value) {
      settingDataset = value;
      if (settingDataset != null) {
        if (settingDataset?.notificationPermit == null) {
          settingDataset?.notificationPermit = false;
        }

        List<String> indexList = settingDataset!.dayInWeek.split(',');
        if (indexList.length > 0) {
          for (var item in indexList) {
            if (int.tryParse(item) != null) {
              dayUserChoose[int.parse(item)] = true;
            }
          }
        }
        List<String> splitTimeDay = settingDataset!.notiTime.split(",");
        if (int.tryParse(splitTimeDay[0]) != null && int.tryParse(splitTimeDay[1]) != null) {
           notificationTime = TimeOfDay(
            hour: int.parse(splitTimeDay[0]),
            minute: int.parse(splitTimeDay[1]));
        }
       
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(AppLocalizations.of(context).notifications).customAppBar(context),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              SizedBox(height: PaddingConstants.large),
              settingDataset != null &&
                      settingDataset!.notificationPermit == false
                  ? ElevatedButton(
                      onPressed: () {
                        DialogController.showInfoDialog(
                            title:
                                AppLocalizations.of(context).askNotiTitle,
                            context: context,
                            actionPositive: () async {
                              var result = await AwesomeNotifications()
                                  .requestPermissionToSendNotifications(
                                      channelKey: "NotificationForLearnApp",
                                      permissions: [
                                    NotificationPermission.Badge,
                                    NotificationPermission.Alert,
                                    NotificationPermission.Sound,
                                    NotificationPermission.Vibration
                                  ]);
                              if (result) {
                                settingDataset?.notificationPermit = true;
                                profileService.userSetting = settingDataset;
                                profileService.updateSetting();
                                DialogController.dismisDialog();
                                setState(() {
                                  
                                });
                              } else {
                                 settingDataset?.notificationPermit = true;
                                profileService.userSetting = settingDataset;
                                profileService.updateSetting();
                                 DialogController.dismisDialog();
                                setState(() {
                                   
                                 });
                              }
                            },
                            buttonNamePositive: AppLocalizations.of(context).yes,
                            buttonNameNegative: AppLocalizations.of(context).no);
                      },
                      child: Text(AppLocalizations.of(context).enableNotiButton),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(350, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        primary: Color(0xff1877F2),
                        elevation: 2,
                        padding: const EdgeInsets.all(10),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: PaddingConstants.large,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
               
                child:
                
                 settingDataset != null &&
                      settingDataset!.notificationPermit == true ?
                 Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 5.0,
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          
                          SizedBox(
                            height: PaddingConstants.large,
                          ),
                          Text(AppLocalizations.of(context).weekday,
                              style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(
                            height: PaddingConstants.large,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: dayUserChoose[0]
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.grey.shade400,
                                radius: 20,
                                child: IconButton(
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  icon: Text("2",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  onPressed: () {
                                    dayUserChoose[0] = !dayUserChoose[0];
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: PaddingConstants.small,
                              ),
                              CircleAvatar(
                                backgroundColor: dayUserChoose[1]
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.grey.shade400,
                                radius: 20,
                                child: IconButton(
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  icon: Text("3",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  color: Colors.white,
                                  onPressed: () {
                                    dayUserChoose[1] = !dayUserChoose[1];
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: PaddingConstants.small,
                              ),
                              CircleAvatar(
                                backgroundColor: dayUserChoose[2]
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.grey.shade400,
                                radius: 20,
                                child: IconButton(
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  icon: Text("4",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  color: Colors.white,
                                  onPressed: () {
                                    dayUserChoose[2] = !dayUserChoose[2];
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: PaddingConstants.small,
                              ),
                              CircleAvatar(
                                backgroundColor: dayUserChoose[3]
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.grey.shade400,
                                radius: 20,
                                child: IconButton(
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  icon: Text("5",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  color: Colors.white,
                                  onPressed: () {
                                    dayUserChoose[3] = !dayUserChoose[3];
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: PaddingConstants.small,
                              ),
                              CircleAvatar(
                                backgroundColor: dayUserChoose[4]
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.grey.shade400,
                                radius: 20,
                                child: IconButton(
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  icon: Text("6",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  color: Colors.white,
                                  onPressed: () {
                                    dayUserChoose[4] = !dayUserChoose[4];
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: PaddingConstants.small,
                              ),
                              CircleAvatar(
                                backgroundColor: dayUserChoose[5]
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.grey.shade400,
                                radius: 20,
                                child: IconButton(
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  icon: Text("7",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  color: Colors.white,
                                  onPressed: () {
                                    dayUserChoose[5] = !dayUserChoose[5];
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: PaddingConstants.small,
                              ),
                              CircleAvatar(
                                backgroundColor: dayUserChoose[6]
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.grey.shade400,
                                radius: 20,
                                child: IconButton(
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  icon: Text(
                                      AppLocalizations.of(context)
                                          .sunday
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  color: Colors.white,
                                  onPressed: () {
                                    dayUserChoose[6] = !dayUserChoose[6];
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: PaddingConstants.large,
                          ),
                          Divider(
                              height: 0,
                              indent: 0,
                              thickness: 0,
                              color: Colors.black54),
                          SizedBox(
                            height: PaddingConstants.large,
                          ),
                          ListTile(
                            title: Text(AppLocalizations.of(context).startAt,
                                style: Theme.of(context).textTheme.titleMedium),
                            trailing: ElevatedButton(
                              child: Text(
                                notificationTime != null
                                    ? notificationTime!.format(context)
                                    : AppLocalizations.of(context).chooseTime,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                              onPressed: dayUserChoose.contains(true)
                                  ? () async {
                                      notificationTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now());
                                      setState(() {});
                                    }
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: PaddingConstants.large,
                          ),
                          Divider(
                              height: 0,
                              indent: 0,
                              thickness: 0,
                              color: Colors.black54),
                          SizedBox(
                            height: PaddingConstants.large,
                          ),
                          LoginButton(
                    onPressed: () {
                      List<String> appendIndexString = [];
                      AwesomeNotifications().cancelSchedulesByChannelKey(
                          NotificationController.ChannelKey);
                      for (int i = 0; i < dayUserChoose.length; i++) {
                        if (dayUserChoose[i] == true) {
                          appendIndexString.add(i.toString());
                          NotificationController.createNotification(
                              AppLocalizations.of(context).notiTile,
                              AppLocalizations.of(context).notification1,
                              this.notificationTime!,
                              i + 1);
                        }
    
                        this.settingDataset?.dayInWeek =
                            appendIndexString.join(",");
                        this.settingDataset?.notiTime =
                            this.notificationTime!.hour.toString() +
                                "," +
                                this.notificationTime!.minute.toString();
                        profileService.userSetting = this.settingDataset;
                        profileService.updateSetting();
                        roundedLoadingButtonController.reset();
                      }
                    },
                    buttonLabel: AppLocalizations.of(context).saveButton,
                    roundedLoadingButtonController:
                        this.roundedLoadingButtonController)
                        ]),
                  ),
                ) : SizedBox.shrink(),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
