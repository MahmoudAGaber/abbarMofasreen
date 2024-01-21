import 'package:dream2/my_library.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import 'package:dream2/view/auth/screens/sign_in2.dart';
import 'package:dream2/view/auth/widgets/phone_widget.dart';

import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  String? phoneNo;

  Map? countryMap;

  setCountry(Map map) => this.countryMap = map;

  setPhone(String value) => this.phoneNo = value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Helper.myPreferredSize,
          child: CustomAppBar(
            title: 'أدخل رقم هاتفك',
            withBack: false,
          )),
      body: Padding(
        padding: Helper.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 32.h,
            ),
            CustomText(
              'سيرسل لك واتساب رسالة نصية قصيرة\nللتحقق من رقم هاتفك',
              fontSize: 16,
              color: AppColors.textColor1,
              fontWeight: FontWeight.w600,
              height: 1.5625,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 34.h,
            ),
            CustomDrop(
              onTap: (map) {
                print(map);
              },
              listItem: [
                {
                  'name': 'الإمارات',
                  'id': 1,
                },
                {
                  'name': 'فلسطين',
                  'id': 2,
                },
              ],
              keyApi: 'name',
              //pass first id ,
              initValue: 1,
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: Get.width,
                height: 50,
                child: IntlPhoneField(
                  validator: (value) {
                    return Helper.validationNull(value!);
                  },
                  autoValidate: false,
                  onSaved: (newValue) {
                    setPhone(newValue!.completeNumber);
                    print(newValue.completeNumber);
                  },
                  decoration: phoneDecoration,
                  initialCountryCode: 'AE',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                    setPhone(phone.completeNumber);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 21.h,
            ),
            CustomText(
              'قد تسري عليك رسوم الرسائل النصية \nالتي تفرضها شركة الاتصالات',
              fontSize: 14,
              color: const Color(0xff8d8d8d),
              textAlign: TextAlign.center,
              height: 1.5.h,
            ),
            SizedBox(
              height: 84.h,
            ),
            CustomButton(
              borderRadius: BorderRadius.zero,
              onTap: () {
                Get.to(() => SignIn2(),
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 500),
                    transition: Transition.fadeIn);
              },
            ),
            SizedBox(
              height: 64.h,
            ),
            CustomText(
              'وظفني',
              fontSize: 14,
              color: const Color(0xffa7a4a4),
              decoration: TextDecoration.underline,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration phoneDecoration = InputDecoration(
    hintText: '0000-00000',
    hintStyle: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 15.sp,
      color: Color(0xff6a7881).withOpacity(0.8),
      fontWeight: FontWeight.w600,
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  );
}
