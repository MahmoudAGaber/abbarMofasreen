import 'package:dream2/my_library.dart';
import 'package:dream2/server/app_provider.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BottomNavHome extends StatelessWidget {
  List<String> iconsImages = [
    'Iconly-Light-Edit Square',
    'Iconly-Light-Chat',
    'setting',
  ];
  List<String> iconsImagesActive = [
    'Edit Square',
    'Iconly-Bold-Chat',
    'Iconly-Bold-Setting',
  ];
  List<String> iconNames = [
    'طلبات التفسير',
    'الدردشات',
    'الاعدادات',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, value, child) => Container(
        width: 353.w,
        height: 83.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0.r),
          color: const Color(0xfff6f6f6),
          boxShadow: AppShadow.shadow20,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: value.indexScreen,
          onTap: value.setIndexScreen,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: [
            ...List.generate(
              iconsImages.length,
              (index) => BottomNavigationBarItem(
                activeIcon: Column(
                  children: [
                    CustomSvgImage(
                      imageName: iconsImagesActive[index],
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(
                      height: 3.4.h,
                    ),
                    CustomText(iconNames[index],
                        fontSize: 10,
                        color: AppColors.primaryColor,
                        height: 1.5.h,
                        letterSpacing: -0.241.w),
                  ],
                ),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        CustomSvgImage(
                          imageName: iconsImages[index],
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(
                          height: 3.4.h,
                        ),
                        CustomText(iconNames[index],
                            fontSize: 10,
                            color: Color(0xff8E8E93),
                            height: 1.5.h,
                            letterSpacing: -0.241.w),
                      ],
                    ),
                    Visibility(
                      visible: index != 2,
                      child: Positioned(
                        left: 7.w,
                        child: Container(
                          height: 11.h,
                          width: 11.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xffff0000),
                          ),
                          alignment: Alignment.center,
                          child: CustomText(
                            index == 0 ? '5' : '7',
                            fontSize: 8,
                            color: Colors.white,
                            height: 1.2.h,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                label: iconNames[index],
              ),
            )
          ],
        ),
      ),
    );
  }
}
