import 'dart:math';

import 'package:dream2/my_library.dart';
import 'package:flutter/material.dart';




import 'package:get/get.dart';

class Helper {

  static EdgeInsetsGeometry defaultPadding =
  EdgeInsets.symmetric(horizontal: 16.w);


  static double myAppBarHeight = AppBar().preferredSize.height;

  static Size myPreferredSize = Size(Get.width, myAppBarHeight);


  static String limitString(String text, int limit) {
    return text.toString().substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? "..." : '');
  }







  ///validation
  static validationEmail(String data) {
    if (data == null || data == '') {
      return 'حقل فارغ';
    } else if (!GetUtils.isEmail(data)) {
      return 'البريد الالكتروني غير صحيح , يرجى المحاولة مرة اخرى';
    }
  }

  static validationNull(String data) {
    if (data == null || data == '') {
      return 'حقل فارغ';
    }
  }

  static validationString(String data) {
    if (data == null || data == '') {
      return 'حقل فارغ';
    } else if (data.length < 8) {
      return 'يجب ان يكون اكثر من 8 خانات';
    }
  }






}

class Note {


  /// FocusScope.of(context).unfocus();

}
