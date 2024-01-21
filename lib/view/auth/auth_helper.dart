import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:dream2/models/dream.dart';
import 'package:dream2/models/user.dart';
import 'package:dream2/server/app_provider.dart';
import 'package:dream2/view/auth/models/add_dream_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  List<dynamic> chats = [];
  String dreamCreatorId = '';
  String dreamCreatorPhoneNum = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int max = 100;
  User theUser = new User(
      token: "",
      tokenType: "bearer",
      name: "GUEST",
      expiryDate: 0,
      image: "",
      firebaseId: "");

  AuthHelper._();

  bool loadingDreams = false;
  static AuthHelper authHelper = AuthHelper._();
  Dio dio = Dio();

  bool get isAuth {
    return theUser.token != "";
  }

  Future<bool?> fetchDreams(int start, int count, BuildContext context) async {
    try {
      if (start != 0 &&
          max <=
              Provider.of<AppProvider>(context, listen: false)
                      .userDreams
                      .length -
                  1) {
        print("no more data");
      } else {
        Response response = await dio.get(
            'http://mks2000-001-site1.etempurl.com/odata/Dreams?\$inlinecount=allpages&\$top=$count&\$skip=$start&\$orderby=CreationDate &\$filter=Status eq \'Active\'  or Status eq \'Under_Interpretation\'',
            // 'http://mks2000-001-site1.etempurl.com/odata/Dreams?\$inlinecount=allpages&\$top=$count&\$skip=$start&\$orderby=CreationDate &\$filter=Status eq \'Active\'',
            options: Options(contentType: "application/x-www-form-urlencoded"));
        print(':::::::::::::::::::::::::::${response.data.toString()}');
        max = double.parse(response.data["odata.count"].toString()).toInt();
        List<Dream> extraDreams = [];
        List<dynamic> onlineDreams = response.data["value"];
        onlineDreams.forEach((element) {
          final localDream = Dream(
            status: element["Status"].toString(),
            description: element["Description"].toString(),
            serviceProviderId: element["ServiceProviderId"].toString(),
            servicePathId: element["ServicePathId"].toString(),
            explanation: element["Explanation"].toString(),
            explanationDate: element["ExplanationDate"].toString(),
            phoneNumber: element["PhoneNumber"].toString(),
            paymentId: element["PaymentId"].toString(),
            id: element["id"].toString(),
            creationDate: element["CreationDate"].toString(),
            lastModificationDate: element["LastModificationDate"].toString(),
            creatorId: element["CreatorId"].toString(),
            modifierId: element["ModifierId"].toString(),
            attachmentId: element["AttachmentId"].toString(),
            creatorName: element["Status"].toString(),
          );
          extraDreams.add(localDream);
          print(localDream.description);
        });
        Provider.of<AppProvider>(context, listen: false)
            .updateDreams(extraDreams, start);
        // if (start == 0) {
        //   userDreams.clear();
        //   userDreams.addAll(extraDreams);
        // } else {
        //   userDreams.addAll(extraDreams);
        // }

        // if (response.data['access_token'] != null) {
        //
        // } else {
        //   return false;
        // }}
      }
    } catch (e) {
      print("e is $e");
      throw 'Could not authenticate you, please try again later';
    }
  }

  Future<bool> transferDream(int dreamId) async {
    try {
      print('::::::::::::::::::::::::::::');
      print(dreamId.toString());
      print(theUser.id);
      print(theUser.token);
      final response = await dio.get(
        'http://mks2000-001-site1.etempurl.com/api/actions/TransferDream?dreamId=$dreamId&interpreterId=${theUser.id}',
        options: Options(
          contentType: "application/x-www-form-urlencoded",
          headers: {'Token': 'Bearer ${theUser.token}'},
        ),
      );
      print(':::::::::::::::::::::::::::${response.data.toString()}');

      // userDreams.addAll(extraDreams);/

      // if (response.data['access_token'] != null) {
      //
      // } else {
      //   return false;
      // }}
      return true;
    } catch (e) {
      print("لم نتمكن من تحويل الحلم is ${e}");
      return false;
    }
  }

  Future<bool> endDreams(int dreamId, String chatID) async {
    try {
      Response response = await dio.get(
        'http://mks2000-001-site1.etempurl.com/api/actions/FinishDream?dreamId=$dreamId&interpreterId=${theUser.id}',
        options: Options(
          contentType: "application/x-www-form-urlencoded",
          headers: {'Token': 'Bearer ${theUser.token}'},
        ),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final firestore = FirebaseFirestore.instance;
        firestore.collection('chat').doc(chatID).update({
          'isFinished': true,
          'allDone': true,
        });
      }
      print(
          "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::${response.data}");

      return true;
    } catch (e) {
      print("e is $e");
      return false;
      // throw 'Could not authenticate you, please try again later';
    }
  }

  Future<bool> reciveDreams(
    int dreamId,
    String creatorId,
    String dreamText,
    BuildContext context,
  ) async {
    print(
        "http://mks2000-001-site1.etempurl.com/api/actions/ReceiveDream?dreamId=$dreamId&interpreterId=${theUser.id}");
    try {
      Response response = await dio.get(
        'http://mks2000-001-site1.etempurl.com/api/actions/ReceiveDream?dreamId=$dreamId&interpreterId=${theUser.id}',
        options: Options(
          contentType: "application/x-www-form-urlencoded",
          headers: {'Authorization': 'Bearer ${theUser.token}'},
        ),
      );
      if (response.statusCode == 200) {
        Provider.of<AppProvider>(context, listen: false)
            .userDreams
            .removeWhere((element) => int.parse(element.id) == dreamId);
        print(response.data["Dream"]["Status"]);
        // if (response.data["Dream"]["Status"] == "Active") {
        dreamCreatorId = response.data["CreatorId"];
        dreamCreatorPhoneNum = response.data["Dream"]["PhoneNumber"];
        print(dreamCreatorId);
        print(dreamCreatorPhoneNum);
        final acceptedDreamId = response.data["DreamId"];
        createChat(
            dreamCreatorId, dreamCreatorPhoneNum, acceptedDreamId, dreamText);
        return true;
      } else {
        throw response.data;
      }
      // } else {
      //   return false;
      // }
    } catch (e) {
      print("e is $e");
      print((e as DioError).response.toString());
      if (e is DioError) {
        final error = e;
        throw error.response?.data ?? '';
      } else
        throw e;
    }
  }

  // void getChats(List<String> c) {
  //   chats = c;
  // }

  Future<bool?> createChat(
      String creatorId, String phone, dynamic dreamId, String dreamText) async {
    String chatId = '';
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('chat').add({
        'Id': '',
        'providerId': theUser.id,
        'dreamText': dreamText,
        'explainerName': theUser.name,
        'userNumber': phone,
        'dreamId': dreamId,
        'isFinished': false,
        'allDone': false,
        'dateExplained': '',
        'deleted': {
          'user': false,
          'explainer': false,
        },
        'lastMessage': {
          'msg': 'السلام عليكم ورحمة الله وبركاته',
          'fromExplainer': true,
          'timeSent': DateTime.now().toUtc(),
        },
        'messages': [
          {
            "createdAt": Timestamp.now(),
            "senderId": theUser.id,
            "text": "السلام عليكم ورحمة الله وبركاته"
          }
        ]
      }).then((value) async {
        dynamic userToken;
        print("this is chat id  ::  ${value.id}");
        chatId = value.id;
        firestore.collection('chat').doc(chatId).update({"Id": value.id});
        final data = await firestore
            .collection('explainers')
            .doc(theUser.firebaseId)
            .get();
        print(data['chats']);
        chats = data['chats'];
        chats.add(chatId);
        firestore
            .collection('explainers')
            .doc(theUser.firebaseId)
            .update({'chats': chats});

      await  FirebaseDatabase.instance.ref("users").child("Token").child(phone).get().then((value) {
        Map<dynamic,dynamic>?ff=value.value as Map?;
        userToken=ff!['token'];
        });
        // final fire2 = firestore.collection('users');
        // final collection = await fire2.get();
        // print(collection.docs.length);
        // collection.docs.forEach((element) {
        //   print("searching by $creatorId");
        //   if (element.data()['phone'] == phone) {
        //     userToken = element.data()['tokens'];
        //   }
        //
        //   if (creatorId == element["creatorId"]) {
        //     // print("mawgood ${element["name"]}  and id is ${element.id}");
        //     print(element['chats']);
        //     List<dynamic> userChats = element['chats'];
        //     userChats.add(chatId);
        //     print(userChats);
        //     fire2.doc(element.id).update({'chats': userChats});
        //   }
        // });
        print(':::::::::: ${userToken.toString()} + chatId $chatId  ');
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'sendMsg',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 10),
          ),
        );
        callable.call({
          'tokens': userToken,
          'title': 'رساله جديده',
          'body': "السلام عليكم ورحمة الله وبركاته",
          'extraData': {
            'route': 'chat',
            'id': chatId,
            'name': theUser.name,
            'dreamText': dreamText,
          }
        });
      });

      // firestore.collection('users').doc(creatorId).set({'field_name': 'Some new data'});

    } catch (e) {
      print("e is $e");
      return false;
      // throw 'Could not authenticate you, please try again later';
    }
  }

  Future getsingleuser() async{
    final

   response = await http.get(
                            Uri.parse( 'http://mks2000-001-site1.etempurl.com/api/controlPanel/GetEmployeesList'),
    headers: {
      "contentType": "application/x-www-form-urlencoded",
      "headers": 'Authorization Bearer ${theUser.token}',
    },
      );
      print("dsds23${response.body}");


   final nn=jsonDecode(response.body);

print("dsds24$nn");
    nn.forEach((value) {

      Map<String,dynamic> vcvc=   ( value as Map<String,dynamic>);
      //    print("sasasas${vcvc['availableBalance']}");

      if(vcvc['Id'].toString().contains( theUser.id.toString()))
      {
        // final prefs = await _prefs;

        print("sasasas${vcvc['sentBalance']}");


        theUser.numberOfInterpretedDreams=  int.parse( vcvc['numberOfDoneDreams'].toString());
        theUser.availableBalance=   double.parse( vcvc['numberOfDoneDreams'].toString())*0.25;
        theUser.transferedBalance=  double.parse( vcvc['sentBalance'].toString());





      }

      print("dsds25$value");



    });
    final prefs = await _prefs;

    prefs.setStringList("userData", [
      theUser.email!,
      theUser.id!,
      theUser.phone!,
      theUser.numberOfInterpretedDreams.toString(),
      theUser.availableBalance.toString(),
      theUser.transferedBalance.toString(),
      theUser.token!,
      theUser.tokenType!,
      theUser.name!,
      theUser.image!,
      DateTime.now()
          .add(Duration(days: theUser.expiryDate!))
          .toIso8601String(),
    ]);
    return nn;


  }


  Future<bool?> deletehUserInfo() async {
    try {

      final prefs = await _prefs;

      final data=prefs.getStringList("userData");
      print("dsds${data![1]}");

      Response response = await dio.get(
        'http://mks2000-001-site1.etempurl.com/api/Account/DeleteSingleUser?Id=${data[1]}',
        options: Options(
          contentType: "application/x-www-form-urlencoded",
          headers: {'Authorization': 'Bearer ${data[6]}'},
        ),
      );



   //   logout();

//       if (response.data['id'] != null) {
//
//         //  print("dfgh${maxx.data}");
//         // theUser.email = response.data['Email'];
//         // theUser.id = response.data['id'];
//         // theUser.phone = response.data['PhoneNumber'];
//
//
// //        print("dsds233$nn");
//
//
//
//
//         // theUser.numberOfInterpretedDreams =
//
//         // theUser.numberOfInterpretedDreams =
//         //     response.data['NumberOfInterpretedDreams'];
//         // theUser.availableBalance = response.data['AvailableBalance'];
//         // theUser.transferedBalance = response.data['transferedBalance'];
//         // final prefs = await _prefs;
//         //
//         // prefs.setStringList(""userData"", [
//         //   theUser.email,
//         //   theUser.id,
//         //   theUser.phone,
//         //   theUser.numberOfInterpretedDreams.toString(),
//         //   theUser.availableBalance.toString(),
//         //   theUser.transferedBalance.toString(),
//         //   theUser.token,
//         //   theUser.tokenType,
//         //   theUser.name,
//         //   theUser.image,
//         //   DateTime.now()
//         //       .add(Duration(days: theUser.expiryDate))
//         //       .toIso8601String(),
//         // ]);
//       }
    } catch (e ) {
      print("e is ${(e as DioError).error}");
      throw 'Could not authenticate you, please try again later';
    }

    getsingleuser();


  }



  Future<bool?> fetchUserInfo() async {
    try {
      Response response = await dio.get(
        'http://mks2000-001-site1.etempurl.com/api/Account/UserInfo',
        options: Options(
          contentType: "application/x-www-form-urlencoded",
          headers: {'Authorization': 'Bearer ${theUser.token}'},
        ),
      );
      print("dsds${response.data}");
      if (response.data['id'] != null) {

      //  print("dfgh${maxx.data}");
        theUser.email = response.data['Email'];
        theUser.id = response.data['id'];
        theUser.phone = response.data['PhoneNumber'];


//        print("dsds233$nn");




       // theUser.numberOfInterpretedDreams =

        // theUser.numberOfInterpretedDreams =
        //     response.data['NumberOfInterpretedDreams'];
        // theUser.availableBalance = response.data['AvailableBalance'];
        // theUser.transferedBalance = response.data['transferedBalance'];
        // final prefs = await _prefs;
        //
        // prefs.setStringList("userData", [
        //   theUser.email,
        //   theUser.id,
        //   theUser.phone,
        //   theUser.numberOfInterpretedDreams.toString(),
        //   theUser.availableBalance.toString(),
        //   theUser.transferedBalance.toString(),
        //   theUser.token,
        //   theUser.tokenType,
        //   theUser.name,
        //   theUser.image,
        //   DateTime.now()
        //       .add(Duration(days: theUser.expiryDate))
        //       .toIso8601String(),
        // ]);
      }
    } catch (e ) {
      print("e is ${(e as DioError).error}");
      throw 'Could not authenticate you, please try again later';
    }

      getsingleuser();


  }

  Future<bool> login(
      String userName, String password, BuildContext context) async {
    try {
      Response response = await dio.post(
          'http://mks2000-001-site1.etempurl.com/Token',
          data: {
            'username': userName,
            'password': password,
            'grant_type': 'password'
          },
          options: Options(contentType: "application/x-www-form-urlencoded"));
      if (response.data['access_token'] != null) {
        print(response.data['access_token']);
        print(response.data.toString());

        theUser.token = response.data['access_token'];
        theUser.tokenType = response.data['token_type'];
        theUser.expiryDate = response.data['expires_in'];
        theUser.name = response.data['userName'];

        print("maxzxz${this.theUser.id}");

         final prefs = await _prefs;
         prefs.setString("username", userName);
        prefs.setString("password", password);

        // final prefs = await _prefs;
        // prefs.setStringList("userData", [
        //   theUser.token,
        //   theUser.tokenType,
        //   theUser.name,
        //   theUser.image,
        //   DateTime.now()
        //       .add(Duration(days: theUser.expiryDate))
        //       .toIso8601String(),
        // ]);


        await fetchUserInfo();
        await fetchDreams(0, 10, context);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("e is $e");
      throw 'Could not authenticate you, please try again later';
    }
  }

  Future<void> update(String id) async {
    print("updating firebase id  = $id");
    try {
      theUser.firebaseId = id;
      print("after update firebase id  = ${theUser.firebaseId}");

      final prefs = await _prefs;
      prefs.setStringList("userData", [
        theUser.email!,
        theUser.id!,
        theUser.phone!,
        theUser.numberOfInterpretedDreams.toString(),
        theUser.availableBalance.toString(),
        theUser.transferedBalance.toString(),
        theUser.token!,
        theUser.tokenType!,
        theUser.name!,
        theUser.image!,
        DateTime.now()
            .add(Duration(days: theUser.expiryDate!))
            .toIso8601String(),
        theUser.firebaseId!
      ]);
    } catch (e) {
      print("e is $e");
      throw 'Could not authenticate you, please try again later';
    }
  }

  Future<bool> tryAutoLogin(
    BuildContext context,
  ) async {
    // await fetchCities();
    final SharedPreferences prefs = await _prefs;

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = prefs.getStringList("userData");
    final expiryDate = DateTime.parse(extractedUserData![10]);

    if (expiryDate.isBefore(DateTime.now().add(Duration(seconds: 5)))) {
      return false;
    }

    if (extractedUserData!.isNotEmpty) {
      print("autologin");
      theUser.email = extractedUserData[0];
      theUser.id = extractedUserData[1];
      theUser.phone = extractedUserData[2];
      theUser.numberOfInterpretedDreams =
          double.parse(extractedUserData[3]).toInt();
      theUser.availableBalance = double.parse(extractedUserData[4]);
      theUser.transferedBalance = double.parse(extractedUserData[5]);
      theUser.token = extractedUserData[6];
      theUser.tokenType = extractedUserData[7];
      theUser.name = extractedUserData[8];
      theUser.image = extractedUserData[9];
      theUser.firebaseId = extractedUserData[11];
      await fetchUserInfo();
      // await fetchDreams(0, 10, context);
      return true;
    } else
      return false;
  }

  Future<void> logout() async {
    theUser.name = 'GUEST';
    theUser.token = '';
    theUser.tokenType = '';
    theUser.expiryDate = 0;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
//     prefs.clear();
  }
// Future<String> activeDreams() async {
//   Response response = await dio.get(
//       'http://mks2000-001-site1.etempurl.com/odata/Dreams',
//       options: Options(contentType: "application/x-www-form-urlencoded"));
//   AddDreamResponse addDreamResponse =
//       AddDreamResponse.fromJson(response.data);
//   log(addDreamResponse.toJson().toString());
// }
}
