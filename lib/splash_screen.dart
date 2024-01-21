import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream2/my_library.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import 'package:dream2/view/auth/screens/sign_in2.dart';
import 'package:dream2/view/home_tabs/home_main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/auth/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // svgInit(List<String> svgList) async {
  //   svgList.map((e) async {
  //     return await precachePicture(
  //         ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/$e.svg'),
  //         null);
  //   }).toList();
  // }

  _asyncMethod() async {
  //  await AuthHelper.authHelper.tryAutoLogin(context);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.get("username")!=null) {

    //  Get.offAll(HomeMainScreen());

      try {
       // print(userNameController.text);
       // print(passwordController.text);
        final result = await  AuthHelper.authHelper.login(
            prefs.get("username").toString(), prefs.getString("password").toString(), context);

        bool status = false;
        String firebaseId = '';
        if (result) {
          // print(await firestore.collection('explainers').doc().snapshots().length);
          final fire = FirebaseFirestore.instance.collection('explainers');
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
            await  FirebaseFirestore.instance.collection('explainers').add({
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
         // _showErrorDialog('Could not authenticate you, please try again later');
        }
      } catch (error) {
        print(error);
        var errorMessage = error.toString();
//          'Could not authenticate you, please try again later';
//       _showErrorDialog(errorMessage.toString());
       // _showErrorDialog('Could not authenticate you, please try again later');
      }
      // setState(() {
      //   loading = false;
      // });
    }
    else

      Get.offAll(
              () =>  SignIn2());

    // var delay = Duration(seconds: 1);
    // Future.delayed(delay, () {
    //   Get.offAll(
    //       () => AuthHelper.authHelper.isAuth ? HomeMainScreen() : SignIn2());
    // });
  }

  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: ZoomIn(
            duration: Duration(milliseconds: 1500),
            animate: true,
            controller: (AnimationController ) {  },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: Image.asset(
                  'assets/images/appLogo.jpeg',
                  height: 200.sp,
                  width: 200.sp,
                  fit: BoxFit.fill,
                )),
              ],
            )),
      ),
    );
  }
}
