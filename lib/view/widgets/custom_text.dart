import 'package:flutter/material.dart';
import 'package:dream2/my_library.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final Color? color;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final int? maxLines;
  final List<Shadow>? shadows;

  CustomText(
    this.text, {
    this.fontSize = 18,
    this.textAlign = TextAlign.start,
    this.color,
    this.fontWeight = FontWeight.w500,
    this.maxLines,
    this.shadows,
    this.height,
    this.letterSpacing,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize!.sp,
        color: color,
        fontFamily: "Cairo",
        decoration: decoration,
        letterSpacing: letterSpacing,
        shadows: shadows,
        height: height,
      ),
    );
  }
}
