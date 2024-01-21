import 'package:dream2/my_library.dart';
import 'package:dream2/server/app_provider.dart';

import 'package:dream2/view/home_tabs/screens/write_dream_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DescripeItem extends StatelessWidget {
  final String? dreamTitle, dreamBody;

  final Function? onTap;

  DescripeItem({this.dreamTitle, this.dreamBody, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!() : null,
      child: Container(
        constraints: BoxConstraints(minHeight: 106.h),
        padding: EdgeInsets.only(left: 11.w, right: 17.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0.r),
          color: const Color(0xfff9f9f9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Text(
              'حلم جديد ',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                color: const Color(0xff565656),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 265.w),
              child: CustomText(
                dreamBody ?? 'لا يوجد تفاصيل',
                fontSize: 11,
                color: const Color(0xff707070),
                height: 1.54.h,
                maxLines: 2,
              ),
            ),
            CustomText(
              'عرض المزيد',
              fontSize: 12,
              color: AppColors.primaryColor,
              height: 1.58.h,
              textAlign: TextAlign.end,
            )
          ],
        ),
      ),
    );
  }
}
