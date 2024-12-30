import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:snug_logger/snug_logger.dart';

class NotificationHandler {
  // Initialize FlutterLocalNotificationsPlugin and notification details.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
    'base_notifications',
    'base_notifications',
    channelDescription: 'base_notifications',
    importance: Importance.max,
    priority: Priority.max,
  );

  DarwinNotificationDetails iosDetails = const DarwinNotificationDetails();

  NotificationHandler() {
    // Initialize notification channels and settings.
    _createNotificationChannel();
    _initializeNotification();
  }

  Future<void> _createNotificationChannel() async {
    if (Platform.isAndroid) {
      // Request Android notification permissions.
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      androidPlugin?.requestNotificationsPermission();
    }

    // Create Android notification channel.
    const androidNotificationChannel = AndroidNotificationChannel(
      'app_name', //channel id
      'app_name', //channel name
      importance: Importance.high,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> _initializeNotification() async {
    // Initialize notification settings and request permissions.

    const initializationSettingsAndroid = AndroidInitializationSettings(
        'app_logo'); // change the app_logo with your asset name

    const initializationSettingsIOS = DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      ),
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Details are $details');
        final data = jsonDecode(details.payload ?? "");
        handleNavigation(data as Map<String, dynamic>?);
      },
    );

    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(
      announcement: true,
    );

    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      snugLog('initial message ${initialMessage.data}');
      handleNavigation(initialMessage.data);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      snugLog('Background State:::::::::::::::::: ${event.data}');
      handleNavigation(event.data);
    });

    FirebaseMessaging.onMessage.listen((event) {
      onNotificationReceived(event);
    });
  }

  Future onNotificationReceived(RemoteMessage? event) async {
    if (event == null) {
      return;
    }

    snugLog('Foreground::::::::::::::::::::::::: ${event.data}');
    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      final notificationDetails =
          int.tryParse(event.data['notification_details'] as String? ?? "1") ??
              1;

      await flutterLocalNotificationsPlugin.show(
        notificationDetails,
        event.notification?.title,
        event.notification?.body,
        platformDetails,
        payload: 'notification',
      );
    } catch (e) {
      snugLog('error ::::::::::::::::::::::::::::::::::::::  $e');
    }
  }

  void handleNavigation(Map<String, dynamic>? data) {
    // Handle the notification data and navigate to the appropriate screen.
    // Add your navigation logic here.
  }
}
