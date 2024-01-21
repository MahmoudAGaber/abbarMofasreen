import 'package:flutter/material.dart';

import 'package:dream2/my_library.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Function? onTap;
  final double? height;
  final double? width;
  final BorderRadius borderRadius;

  final EdgeInsetsGeometry? margin;
  final Widget? content;

  final Color? backGroundColor;
  final Color? textColor;
  final Color? borderColor;

  CustomButton({
     this.text,
    this.onTap,
    this.height = 50,
     this.width,
     this.margin,
     this.content,
     this.backGroundColor,
     this.textColor,
     this.borderColor,
     required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      controller: (AnimationController ) {  },
      child: TextButton(
        onPressed: onTap != null ? () => onTap!() : null,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.zero,
          minimumSize: Size(width ?? Get.width, height!.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0.r),
          ),
        ),
        child: content ??
            CustomText(
              text??     'التالي',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.571.h,
            ),
      ),
    );
  }
}
