import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppShadow {
  static List<BoxShadow> shadow036 = [
    BoxShadow(
      color: const Color(0x29000000),
      offset: Offset(0, 3),
      blurRadius: 6,
    ),
  ];

  static shadow012({double blurRadius = 15}) {
    return [
      BoxShadow(
        color: const Color(0x1d000000),
        offset: Offset(0, 12),
        blurRadius: blurRadius,
      ),
    ];
  }

  static List<BoxShadow> shadow20 = [
    BoxShadow(
      color: const Color(0x319e9e9e),
      offset: Offset(0, 2),
      blurRadius: 20.r,
    ),
  ];
}
