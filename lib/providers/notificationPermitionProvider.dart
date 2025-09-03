import 'package:flutter/material.dart';
import 'package:localapp/constants/Config.dart';
import 'package:localapp/constants/prefs_file.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_settings/app_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

final notificationPermissionProvider =
    StateNotifierProvider<NotificationPermissionNotifier, bool>((ref) {
  return NotificationPermissionNotifier(false);
});

class NotificationPermissionNotifier extends StateNotifier<bool> {
  NotificationPermissionNotifier(super.state);

  final _fireBaseMessaging = FirebaseMessaging.instance;
  bool _isDailogOpen = false;


  //
  //
  Future<void> getNotification(BuildContext context) async {



    bool? firstInstall = await Prefs().checkUserFirstInstalled();

    logger.i("$firstInstall");


    if(firstInstall)
      {
        await AwesomeNotifications().requestPermissionToSendNotifications();
        Prefs().setInstallStatus(false);
        await getNotification(context);
        return ;


      }

    var notificationSettings = await _fireBaseMessaging.getNotificationSettings();

    if(notificationSettings.authorizationStatus==AuthorizationStatus.denied)
      {
        _isDailogOpen = true;
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => WillPopScope(
                  onWillPop: ()async{
                    var st = await _fireBaseMessaging.getNotificationSettings();
                    if(st.authorizationStatus==AuthorizationStatus.notDetermined||st.authorizationStatus==AuthorizationStatus.denied)
                      {
                        return false;
                      }
                    else if(st.authorizationStatus==AuthorizationStatus.authorized){
                      return true;
                    }
                    return false;
                  },
                  child: AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications,
                              size: 40,
                            ),
                            Text(
                              "Please provide Notifications Permission to continue.",
                              textAlign: TextAlign.center,
                            ),
                            if (notificationSettings.authorizationStatus ==
                                AuthorizationStatus.denied)
                              ElevatedButton(
                                  onPressed: () async {
                                    AppSettings.openAppSettings(
                                        type: AppSettingsType.notification);
                                    Logger().e("Permission Asked");
                                  },
                                  child: const Text('Open Settings'))
                          ],
                        ),
                      ),
                ));
            _isDailogOpen = false;
            await getNotification(context);
      }
    else if(notificationSettings.authorizationStatus==AuthorizationStatus.notDetermined)
      {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }


  }

  checkDialog(BuildContext context) async {
    if (_isDailogOpen) {
      var b = await _fireBaseMessaging.getNotificationSettings();

      if (b.authorizationStatus == AuthorizationStatus.authorized) {
        Navigator.pop(context);
      }
    }
  }
}
