import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPngImage extends StatelessWidget {
  final String? imageName;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;

  CustomPngImage(
      {this.imageName, this.height = 30, this.width = 30, this.color, this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$imageName.png',
      height: height!.h,
      width: width!.w,
      fit: fit ?? BoxFit.fill,
      color: color,
    );
  }
}

class CustomSvgImage extends StatelessWidget {
  final String? imageName;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;

  CustomSvgImage({
    this.imageName,
    this.height =24,
    this.width =24,
    this.color, this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/$imageName.svg',
      height: height!.h  ,
      width: width!.w ,
      fit: fit ?? BoxFit.contain,
      color: color,
    );
  }
}

class CustomLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  CustomLogo({this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "logo",
      child: CustomPngImage(
        imageName: "logo",
        width: width ?? 98.w,
        height: height ?? 96.h,
        fit: BoxFit.contain,
        color: color,

      ),
    );
  }
}

