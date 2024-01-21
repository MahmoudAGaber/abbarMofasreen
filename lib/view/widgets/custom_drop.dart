import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dream2/my_library.dart';

class CustomDrop extends StatefulWidget {
  final List<dynamic>? listItem;
  int? initValue;
  final Function? onTap;
  final String? keyApi;

  CustomDrop({this.listItem, this.initValue, this.onTap, this.keyApi});

  @override
  _CustomDropState createState() => _CustomDropState();
}

class _CustomDropState extends State<CustomDrop> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(

      underline: Container(
        height: 0.5.h,
        color: AppColors.primaryColor,
      ),
      dropdownColor: Colors.white,
      value: widget.initValue,
     iconEnabledColor: AppColors.primaryColor,
      isExpanded: true,
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      style: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 15.sp,
      color: const Color(0xff6a7881),
      fontWeight: FontWeight.w600,
      height: 1.5333333333333334,
    ),
      items: widget.listItem!.map((var valueMap) {
        return DropdownMenuItem(
          child: Padding(
            padding: EdgeInsets.only(right: 19.w),
            child: CustomText(
              valueMap[widget.keyApi],
              fontSize: 15,
              color: const Color(0xff849198),
              textAlign: TextAlign.center,
            ),
          ),
          value: valueMap['id'],
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          widget.initValue = value as int?;
          var findMap = widget.listItem!
              .firstWhere((element) => element['id'] == value);
          widget.onTap!(findMap);
        });
      },
      iconDisabledColor: Colors.black.withOpacity(0.7),
      iconSize: 30.r,
    );
  }
}
