import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dream2/my_library.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import 'package:dream2/view/home_tabs/home_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignIn2 extends StatefulWidget {
  @override
  State<SignIn2> createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  String? code;
  bool loading = false;

  setPhone(String value) => this.code = value;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                backgroundColor: Colors.black45,
                title: Text(
                  'حدث خطأ',
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  'من فضلك تأكد من اسم المستخدم وكلمه السر',
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(
                      'تأكيد',
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

  Future whatsapp(String number, String message) async {
    final whatsappURlAndroid =
        "https://wa.me/$number/?text=${Uri.parse(message)}";
    final whatsappURLIos =
        "https://api.whatsapp.com/send?phone=$number=${Uri.parse(message)}";
    try {
      if (await canLaunch(
          Platform.isIOS ? whatsappURLIos : whatsappURlAndroid)) {
        await launch(
          Platform.isIOS ? whatsappURLIos : whatsappURlAndroid,
          // forceSafariVC: false,
          // forceWebView: true,
        );
      }
    } catch (e) {
      print('Can not launch whats app :: ${e.toString()}');
    }
  }

  Future<void> _submit() async {
    final firestore = FirebaseFirestore.instance;

    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    // _formKey.currentState.save();
    setState(() {
      loading = true;
    });
    try {
      print(userNameController.text);
      print(passwordController.text);
      final result = await AuthHelper.authHelper.login(
        userNameController.text,
        passwordController.text,
        context,
      );

      bool status = false;
      String firebaseId = '';
      if (result) {
      print( "madmaxx${AuthHelper.authHelper.theUser.id}");

        // print(await firestore.collection('explainers').doc().snapshots().length);
        // FirebaseAuth.instance.signInWithEmailAndPassword(email: "${userNameController.text}@abber.com",password: passwordController.text).then((value) {
        //
        //
        // }).onError((FirebaseAuthException  error, stackTrace){
        //
        //
        //   if(error.message=="user-not-found")
        //     {
        //       print("sweart");
        //
        //       FirebaseAuth.instance.createUserWithEmailAndPassword(email: userNameController.text, password: passwordController.text).then((value) {
        //         FirebaseAuth.instance.signInWithEmailAndPassword(email: userNameController.text,password:passwordController.text  );
        //       }).onError((FirebaseAuthException error, stackTrace) {
        //
        //       });
        //     }
        //
        //   print("sasamax${error.code}");
        // });
        final fire = firestore.collection('explainers');
        final collection = await fire.get();
        print(collection.docs.length);
        collection.docs.forEach((element) {
          if (AuthHelper.authHelper.theUser.name == element["name"]) {
            print("mawgood ${element["name"]}  and id is ${element.id}");
            status = true;
            firebaseId = element.id;
          }
        });
        if (!status) {
          print("msh mawgood");
          await firestore.collection('explainers').add({
            'name': AuthHelper.authHelper.theUser.name,
            'chats': [],
            'tokens': [],
          }).then((value) => firebaseId = value.id);
        }

        AuthHelper.authHelper.update(firebaseId);

        Get.to(() => HomeMainScreen(),
            curve: Curves.ease,
            duration: Duration(milliseconds: 500),
            transition: Transition.fadeIn);
      } else {
        _showErrorDialog('Could not authenticate you, please try again later');
      }
    } catch (error) {
      print(error);
      var errorMessage = error.toString();
//          'Could not authenticate you, please try again later';
//       _showErrorDialog(errorMessage.toString());
      _showErrorDialog('Could not authenticate you, please try again later');
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Helper.myPreferredSize,
          child: CustomAppBar(
            title: 'تسجيل الدخول',
            withBack: false,
          )),
      body: Padding(
        padding: Helper.defaultPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 32.h,
              ),
              CustomTextFormField(
                hintText: 'اسم المستخدم',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: CustomSvgImage(
                    imageName: 'Profile',
                  ),
                ),
                textEditingController: userNameController,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextFormField(
                hintText: 'كلمة المرور',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: CustomSvgImage(
                    imageName: 'Unlock',
                  ),
                ),
                password: true,
                textEditingController: passwordController,
              ),
              SizedBox(
                height: 26.5.h,
              ),
              CustomText(
                'هل تجيد التفسير؟ ',
                fontSize: 16,
                color: const Color(0xff585757),
                fontWeight: FontWeight.w600,
                height: 1.56.h,
                textAlign: TextAlign.right,
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                children: [
                  CustomSvgImage(
                    imageName: 'Call',
                    width: 19,
                    height: 19,
                  ),
                  SizedBox(
                    width: 4.5.w,
                  ),
                  InkWell(
                    onTap: () async => whatsapp(
                      '+971555661133',
                      'السلام عليكم - ارغب في التوظيف في تطبيق عبر',
                    ),
                    child: CustomText(
                      'تواصل مع الإدارة',
                      fontSize: 14,
                      color: const Color(0xff6a7881),
                      decoration: TextDecoration.underline,
                      height: 1.5.h,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 163.h,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : CustomButton(
                borderRadius: BorderRadius.zero,
                      text: 'تسجيل الدخول',
                      onTap: _submit,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
