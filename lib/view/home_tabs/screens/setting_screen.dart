import 'dart:io';

import 'package:dream2/my_library.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import 'package:dream2/view/auth/screens/sign_in2.dart';
import 'package:dream2/view/auth/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'archive_all_chat_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Helper.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImageShare(
                        (AuthHelper.authHelper.theUser.image).toString(), 55, 55, 10)),
                SizedBox(
                  width: 10.w,
                ),
                CustomText(
                  AuthHelper.authHelper.theUser.name,
                  fontSize: 14,
                  color: const Color(0xff444343),
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(
              height: 37.h,
            ),
            titleAndPrice(
                title: 'عدد الأحلام المفسرة',
                price:
                    '${AuthHelper.authHelper.theUser.numberOfInterpretedDreams}'),
            titleAndPrice(
              title: 'الرصيد المتاح',
              price: '${AuthHelper.authHelper.theUser.availableBalance}\$',
            ),
            titleAndPrice(
                title: 'الرصيد المحول',
                price: '${AuthHelper.authHelper.theUser.transferedBalance}\$'),
            SizedBox(
              height: 33.h,
            ),

            CustomButton(
              borderRadius: BorderRadius.zero,
              text: 'ارشيف',
              onTap: () async {
                setState(() {
                  loading = true;
                });
                // await AuthHelper.authHelper.logout();
                // setState(() {
                //   loading = false;
                // });



                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => arichveAllChatScreen(),
                  ),
                );
                // Navigator.pushReplacement((c,d) => SignInScreen(),
                //     curve: Curves.ease,
                //     duration: Duration(milliseconds: 500),
                //     transition: Transition.fadeIn);
              },
            ),
            ElevatedButton(

                style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all(Colors.red) ,
                    padding: MaterialStateProperty.all(EdgeInsets.all(10))),
                onPressed: () async {
                  showDialog(context: context, builder: (contx)
                  {
                    return AlertDialog(
                      title:Row(children:[ IconButton(
                        icon:


                        Icon(
                            Icons.cancel
                        ), onPressed: () {
                        Get.back();

                      },
                      )]),
                      content:  Container(

                          width:200.h,
                          height:100.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),

                          child:ListView(
                            children: [
                              Text("يرجي العلم انه سيتم حذف جميع بياناتك والمشتريات الخاصه بك")
                              ,
                              SizedBox(
                                height: 33,
                              ),
                              ElevatedButton(onPressed:() {
                                AuthHelper.authHelper.deletehUserInfo();


                              }, child: Text("تاكيد"))
                            ],
                          )),
                    );






                  });
                },
                child:Text( 'حذف الحساب ',style: TextStyle(color: Colors.white),)),

            CustomButton(
              borderRadius: BorderRadius.zero,
              text: 'تسجيل الخروج',
              onTap: () async {
                setState(() {
                  loading = true;
                });
                await AuthHelper.authHelper.logout();
                setState(() {
                  loading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn2(),
                  ),
                );
                // Navigator.pushReplacement((c,d) => SignInScreen(),
                //     curve: Curves.ease,
                //     duration: Duration(milliseconds: 500),
                //     transition: Transition.fadeIn);
              },
            ),
            if (Platform.isAndroid)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () async {
                    try {
                      if (await canLaunch(
                          'https://play.google.com/store/apps/details?id=com.abber.abber2')) {
                        await launch(
                          'https://play.google.com/store/apps/details?id=com.abber.abber2',
                          // forceSafariVC: false,
                          // forceWebView: true,
                        );
                      }
                    } catch (e) {
                      print('Can not launch whats app :: ${e.toString()}');
                    }
                  },
                  child: CustomText(
                    'تقييم التطبيق',
                    fontSize: 16,
                    color: AppColors.textColor1,
                    fontWeight: FontWeight.w700,
                    height: 1.56.h,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget titleAndPrice({String? title, String? price}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            title,
            fontSize: 16,
            color: const Color(0xff4e4e4e),
            fontWeight: FontWeight.w600,
            height: 1.56.h,
          ),
          CustomText(
            price,
            fontSize: 16,
            color: const Color(0xff4e4e4e),
            fontWeight: FontWeight.w700,
            height: 1.56.h,
          )
        ],
      ),
    );
  }
}
