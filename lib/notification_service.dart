import 'dart:convert';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bdaya_fcm_handler/bdaya_fcm_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import 'package:dream2/view/home_tabs/screens/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  final pushToken = RxString("");
  final newChat = false.obs;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  static NotificationService get to => Get.find();

  void handleMessages(NotificationSource src, RemoteMessage message) async {
    final data = message.data;
    print(message.notification.toString());
    print(Get.currentRoute);
    if (message.notification != null &&
        !Get.currentRoute.contains('/ChatScreen')) {
      try {
        await audioPlayer.open(Audio('assets/audios/tone.mp3'));
      } catch (e) {
        print('Error playing audio : $e');
      }
      Get.snackbar(
        message.notification!.title ?? 'إشعار',
        message.notification!.body!.contains('voice')
            ? 'مقطع صوتى'
            : message.notification!.body ?? "",
        snackPosition: SnackPosition.TOP,
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 15.0,
        ),
        // onTap: (_) => onTapSnack?.call(),
        margin: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 5.0,
        ),
        backgroundColor: Platform.isIOS
            ? const Color(0xFF849CCA).withOpacity(0.5)
            : Colors.grey[300],
        titleText: Text(
          message.notification!.title ?? 'إشعار',
          style: TextStyle(
            color: const Color(0xff8d8d8d),
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
        messageText: Text(
          message.notification!.body ?? '',
          style: TextStyle(
            color: const Color(0xff8d8d8d),
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
        // icon: Icon(
        //   isGood
        //       ? CupertinoIcons.checkmark_seal
        //       : CupertinoIcons.exclamationmark_octagon,
        //   color: isGood ? Colors.green : ColorUtil.errorColor,
        // ),
        onTap: (_) {
          if (data != null && data['route'] == 'chat') {
            Get.to(
              () => ChatScreen(
                data['id'],
                data['name'],
                data['dreamText'] ?? '',
              ),
              curve: Curves.ease,
              duration: Duration(milliseconds: 500),
              transition: Transition.fadeIn,
            );
          }
        },
        borderRadius: 10.0,
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
      );
    }
  }

  void init() {
    if (Get.isRegistered<FCMService>()) {
      Get.find<FCMService>().registerSubscriber(handleMessages);
    }
  }
}
