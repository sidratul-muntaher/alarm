import 'dart:async';

import 'package:alarm_clock/models/alarm_model.dart';
import 'package:alarm_clock/screens/add_alarm.dart';
import 'package:alarm_clock/screens/alarm_page.dart';
import 'package:alarm_clock/screens/list_c.dart';
import 'package:alarm_clock/utils/database_helper.dart';
import 'package:alarm_clock/test.dart';

import 'package:alarm_clock/utils/local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkNotificationPermission();

  await LocalNotifications.init();
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(const Duration(seconds: 1), () {
      // print(event);
      navigatorKey.currentState!.pushNamed('/test',
          arguments: initialNotification?.notificationResponse?.payload);
    });
  }

  runApp(MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(body: MyApp()
          ),
      routes: {
        '/test': (context) => const AlarmPage(),
      }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                ListC()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:const Icon(Icons.alarm, size: 200, color: Colors.cyan,)
    );
  }
}
void checkNotificationPermission() async {
  PermissionStatus status = await Permission.notification.status;

  if (status.isGranted) {
    // Permission is already granted
    print('Notification permission is granted');
  } else {
    // Permission is not granted, request it
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      // Permission is granted after requesting
      print('Notification permission is granted');
    } else {
      // Permission is denied
      print('Notification permission is denied');
    }
  }
}

/*class ListW extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ;
  }


}*/
