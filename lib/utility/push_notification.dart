import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:namma_bike/controller/home/home_controller.dart';
import 'package:namma_bike/helper/storage/local_storage.dart';
import 'dart:async';
import 'package:namma_bike/utility/local_notification_service.dart';
import 'package:provider/provider.dart';

class FireBasePushNotificationService {
  static void notificationControll(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        log('Got a message whilst in the getInitialMessage!');
        if (message?.notification != null) {
          LocalNotificationService.showNotificationCustomSound(
              message!.notification?.title ?? "Alert!",
              message.notification?.body ?? "New order received");
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          LocalNotificationService.showNotificationCustomSound(
              message.notification?.title ?? "Alert!",
              message.notification?.body ?? "New order received");
          log('Message also contained a notification: ${message.notification}');
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          LocalNotificationService.showNotificationCustomSound(
              message.notification?.title ?? "Alert!",
              message.notification?.body ?? "New order received");

          log('Message also contained a notification: ${message.notification!.title}');
        }
      });

      messaging.getToken().then((token) async {
        print("token        ---> $token");
        LocalStorage.saveUserFcmTokenSF(token ?? '');
      });
      log('User granted permission to receive notifications');
    } else {
      log('User declined or has not yet granted permission to receive notifications');
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Got a message whilst in the background!');
    if (message.data.containsKey('data')) {
      log(message.notification?.title ?? "");
      log(message.notification?.body ?? "");
      log(message.data.toString());
      LocalNotificationService.showNotificationCustomSound(
          message.notification?.title ?? "Alert!",
          message.notification?.body ?? "New order received");
      return Future<void>.value();
    }
  }
}
