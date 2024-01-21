import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dream2/models/argument.dart';
import 'package:dream2/models/dream.dart';
import 'package:dream2/my_library.dart';
import 'package:dream2/server/app_provider.dart';
import 'package:dream2/view/auth/auth_helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_main.dart';

class ReadDreamScreen extends StatefulWidget {
  final ScreenArguments? dreamDetails;

  const ReadDreamScreen({Key? key, this.dreamDetails}) : super(key: key);

  @override
  State<ReadDreamScreen> createState() => _ReadDreamScreenState();
}

class _ReadDreamScreenState extends State<ReadDreamScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final dream = widget.dreamDetails!.dream;
    final num = widget.dreamDetails!.num;
    void _showErrorDialog(String message) {
      showDialog(
          context: context,
          builder: (ctx) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AlertDialog(
                  backgroundColor: Colors.black45,
                  title: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Okay',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ),
              ));
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Helper.myPreferredSize,
          child: CustomAppBar(
            title: 'تفاصيل الحلم',
            withBack: true,
          )),
      body: Padding(
        padding: Helper.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(22.w, 20.h, 10.w, 22.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0.r),
                  color: Color(0xfff9f9f9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 9.w),
                      child: Text(
                        'حلم جديد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20.sp,
                          color: const Color(0xff565656),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 9.h ,
                    ),
                    Expanded(
                      child: Scrollbar(
                        thickness: 5.0,
                        thumbVisibility: true,
                        radius: Radius.circular(10.0),
                        child: SingleChildScrollView(
                          child: CustomText(
                            dream.description == "null"
                                ? "explanation will be added soon"
                                : dream.description,
                            fontSize: 15.sp,
                            color: Colors.black,
                            height: 1.54.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 75.h,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.yellow,
                    ),
                  )
                : CustomButton(
              borderRadius: BorderRadius.zero,
                    text: 'استلام',
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      final result = await AuthHelper.authHelper
                          .reciveDreams(
                        int.parse(dream.id),
                        dream.creatorId,
                        dream.description,
                        context,
                      )
                          .then((value) {
                        setState(() {
                          loading = false;
                        });
                        Provider.of<AppProvider>(context, listen: false)
                            .setIndexScreen(1);
                        Get.offAll(() => HomeMainScreen(),
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 500),
                            transition: Transition.fadeIn);
                      }).catchError((exp) {
                        setState(() {
                          loading = false;
                        });
                        // String error = '';
                        // if (error is DioError) {
                        //   error = (exp as DioError).message;
                        //   if (error.isEmpty) {
                        //     error = (exp as DioError).response.data.toString();
                        //   }
                        // } else if (exp is String) {
                        //   error = exp;
                        // }
                        _showErrorDialog(
                            "${exp.toString()}\n لا يمكنك استلام هذا الحلم \n ");
                      });
                      setState(() {
                        loading = false;
                      });
                      // if (result) {
                      //   // go to chats
                      //   // AuthHelper.authHelper
                      //   Get.offAll(() => HomeMainScreen(),
                      //       curve: Curves.ease,
                      //       duration: Duration(milliseconds: 500),
                      //       transition: Transition.fadeIn);
                      //   Provider.of<AppProvider>(context, listen: false)
                      //       .setIndexScreen(1);
                      // } else {
                      //   setState(() {
                      //     loading = false;
                      //   });
                      //   _showErrorDialog("لا يمكنك استلام هذا الحلم");
                      // }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      filled: true,
      focusColor: Color(0xffF9F9F9),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      hintText: 'اكتب هنا',
      hintStyle: TextStyle(
        fontSize: 15.sp,
        color: AppColors.subTextBlack,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.r),
        borderSide: BorderSide(
          color: Color(0xffF9F9F9),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.r),
        borderSide: BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.r),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1.0.w,
        ),
      ),
    );
  }
}
