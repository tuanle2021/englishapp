import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
class NotificationController {
 

 

  static const String  ChannelKey = "NotificationForLearnApp";

  static void setUpAction(BuildContext context) {
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      Navigator.of(context).pushNamed(
        '/home',
      );
    });
  }


  static void createNotification(String notiTitle,String notiBody,TimeOfDay timeOfDay,int weekDay) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: ExtensionMethod.uniqueNotificationId().remainder(100000),
              channelKey: ChannelKey,
              title: notiTitle,
              body: notiBody,
              wakeUpScreen: true,
              category: NotificationCategory.Reminder,
            ),
            schedule: NotificationCalendar(
              weekday: weekDay,
              minute: timeOfDay.minute,
              hour: timeOfDay.hour,
              second: 0,
              millisecond: 0,
              repeats: true
            ));
      }
    });
  }
}
