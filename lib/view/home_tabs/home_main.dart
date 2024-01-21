import 'dart:convert';
import 'dart:async';
import 'package:bdaya_fcm_handler/bdaya_fcm_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dream2/server/app_provider.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import 'package:dream2/view/home_tabs/screens/all_chat_screen.dart';
import 'package:dream2/view/home_tabs/screens/describe_dream_screen.dart';
import 'package:dream2/view/home_tabs/screens/setting_screen.dart';
import 'package:dream2/view/home_tabs/widgets/bottom_nav_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:dream2/my_library.dart';
import 'package:provider/provider.dart';

import '../../notification_service.dart';

class HomeMainScreen extends StatefulWidget {
  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  List<Widget> screens = [
    DescribeDreamScreen(),
    AllChatScreen(),
    SettingScreen(),
  ];

  DateTime? currentBackPressTime;

  initNotifications() async {
    fcmServiceFinder =
        () => Get.isRegistered<FCMService>() ? Get.find<FCMService>() : null;
    final RemoteMessage? msg =
        await Get.put(FCMService(), permanent: true).doInit(
      requestFunc: () async {
        final settings = await FirebaseMessaging.instance.requestPermission(
          announcement: true,
          carPlay: true,
          criticalAlert: true,
          provisional: true,
        );
        return settings;
      },
    );
    Get.put(NotificationService(), permanent: true).init();
    if (msg != null) {
      Get.find<NotificationService>().handleMessages(
        NotificationSource.OnMessageOpenedApp,
        msg,
      );
    }
    final token = NotificationService.to.pushToken.value =
        (await fcmServiceFinder!()?.getToken(
      vapidKey:
          "BJhGQX8WkJ-_6PM04Uyoq81NdjxBro3rv5b6LMokFqBULG4_6Z0-j8Hxufer8k1CAhu1DLTSNnAdp_ZBUDnXvLA",
    ))!;
    print(AuthHelper.authHelper.theUser.firebaseId);
    await FirebaseFirestore.instance
        .collection('explainers')
        .doc(AuthHelper.authHelper.theUser.firebaseId)
        .update({
      'tokens': [token]
    });
    if (token.isNotEmpty) {
      try {
        final dio = Dio();
        final response = await dio.post(
          'http://mks2000-001-site1.etempurl.com/odata/UsersDeviceTokens',
          data: json.encode({
            "PhoneNumber": AuthHelper.authHelper.theUser.phone,
            "token": token
          }),
          options: Options(contentType: "application/json"),
        );
        print(':::::::::::::::::::::::::::${response.data.toString()}');
        print("Done sent FCM token");
      } catch (e) {
        print("Could not sent FCM token");
      }
    }

    print('Token :: $token');
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'انقر مرة أخرى للمغادرة');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  void initState() {
    initNotifications();
    super.initState();

    FirebaseMessaging.instance.subscribeToTopic("newDream");

  //  print("daews${FirebaseAuth.instance.currentUser.uid}");

    FirebaseMessaging.instance.getToken().then((value) {
      FirebaseDatabase.instance.ref("users").child("Token").child((AuthHelper.authHelper.theUser.id).toString()).set({
        "token": value.toString()
      }).onError((FirebaseException  error, stackTrace) {
        print("dadas${error}");

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Consumer<AppProvider>(
          builder: (context, value, child) => screens[value.indexScreen],
        ),
        bottomNavigationBar:
            Container(width: Get.width, height: 83.h, child: BottomNavHome()),
      ),
    );
  }
}
