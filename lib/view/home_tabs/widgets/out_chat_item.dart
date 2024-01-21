import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream2/core/value/colors.dart';
import 'package:dream2/view/widgets/cash_network_image_share.dart';
import 'package:dream2/view/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OutChatItem extends StatelessWidget {
  final String? name, imageUrl, numOfMessage, id, lastMessage;
  final Function? onTap;
  final bool? newMessage;
  final DateTime? date;
  final Function()? onLongPress;

  OutChatItem(
      {this.name,
      this.id,
      this.date,
      this.imageUrl,
      this.numOfMessage,
      this.lastMessage = '',
      this.newMessage = false,
      this.onLongPress,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    print(date.toString());
    return GestureDetector(
      onTap: onTap != null ? () => onTap!() : null,
      onLongPress: () {
        if (onLongPress != null) onLongPress!.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 343.5.w,
          constraints: BoxConstraints(
            minHeight: 85.h,
          ),
          padding: EdgeInsets.only(top: 16.6.h),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Color(0xffAFADAD).withOpacity(0.67),
                      width: 0.2.w))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageUrl!,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      name != null && name!.length > 8
                          ? name!.substring(0, 7) + '****'
                          : 'غير معروف',
                      fontSize: 16,
                      color: AppColors.textColor2,
                      height: 1.64.h,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      lastMessage,
                      fontSize: 14,
                      color: AppColors.textColor2,
                      height: 1.63.h,
                      maxLines: 2,
                    )
                  ],
                ),
              ),
              Spacer(),
              if (date != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                      DateFormat.yMEd().format(date!),
                      fontSize: 12,
                      color: newMessage!
                          ? AppColors.primaryColor
                          : Color(0xff707070),
                      height: 1.6.h,
                    ),
                    CustomText(
                      DateFormat.jm().format(date!),
                      fontSize: 12,
                      color: newMessage!
                          ? AppColors.primaryColor
                          : Color(0xff707070),
                      height: 1.6.h,
                    ),

                    // Visibility(
                    //   visible: newMessage,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(top: 5.h),
                    //     child: Container(
                    //       height: 15.h,
                    //       constraints: BoxConstraints(minWidth: 15.w),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(1000),
                    //         color: AppColors.primaryColor,
                    //       ),
                    //       alignment: Alignment.center,
                    //       padding: EdgeInsets.symmetric(horizontal: 4.w),
                    //       child: CustomText(
                    //         numOfMessage,
                    //         fontSize: 10,
                    //         color: Colors.white,
                    //         height: 1.6.h,
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
