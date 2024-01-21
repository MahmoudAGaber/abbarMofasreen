import 'dart:io';
import 'package:bdaya_fcm_handler/bdaya_fcm_handler.dart';
import 'package:dream2/server/app_provider.dart';
import 'package:dream2/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/value/colors.dart';
import 'my_library.dart';
import 'notification_service.dart';


initializeDependencies() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness:
        Platform.isAndroid ? Brightness.light : Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.grey,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  // await SPHelper.spHelper.initSharedPrefrences();
  // await Firebase.initializeApp();
}
void notifi()
async {

  if(Platform.isIOS)
  {
    NotificationSettings settings = await  FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //   showAlertDialog(context,"تم تفعيل الاشعارات ");

    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      //   showAlertDialog(context,"تم تفعيل الاشعارات من قبل ");

    } else {
      //  showAlertDialog(context,"لقد قمت برفض التفعيل يرجي تفعيلها من الاعدادت ");

    }
  }


}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDependencies();


  runApp(MyApp());
  notifi();

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return  MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>(
              create: (context) => AppProvider(),
            ),
          ],
          child: GetMaterialApp(
            title: 'تطبيق الاحلام',
            theme: ThemeData(
                fontFamily: "Cairo",
                primaryColor: AppColors.primaryColor,
                scaffoldBackgroundColor: Colors.white,
                colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.primaryColor)),
            debugShowCheckedModeBanner: false,
            locale: Locale('ar'),
            fallbackLocale: Locale('ar'),
            localizationsDelegates: [
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            //yohknh
            supportedLocales: [
              Locale('ar', 'AE'),
            ],
            home:  SplashScreen(),
            builder: (ctx,child){
              return MediaQuery(
                data: MediaQuery.of(ctx).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
