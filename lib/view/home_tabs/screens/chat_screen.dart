import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:dream2/my_library.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import 'package:dream2/view/home_tabs/widgets/record.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/in_chat_item.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final String name;
  final String dream;
  final bool dreamFinished;

  ChatScreen(this.id, this.name, this.dream, {this.dreamFinished = false});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  String _enterMassage = "";
  var creatotId = '';
  var length = 0;
  List<dynamic>? messages;
  dynamic dreamId;
  bool isDone = false;
  String dateExplained = '';
  var userToken;
  bool isSending = false;
  bool isRecording = false;
  Map<String, dynamic> deletedMap = {};

  // void _showErrorDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
  //             child: AlertDialog(
  //               backgroundColor: Colors.black45,
  //               title: Text(
  //                 "هل انت متأكد من انهاء الدردشة",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: Text(
  //                     'انهاء',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                   onPressed: () {
  //                     AuthHelper.authHelper.endDreams(
  //                         int.tryParse(dreamId.toString()),
  //                         widget.id.toString());
  //                     deletedMap['explainer'] = true;
  //                     firestore
  //                         .collection('chat')
  //                         .doc(widget.id)
  //                         .update({'deleted': deletedMap});
  //                     Navigator.of(ctx).pop();
  //                     Navigator.of(ctx).pop();
  //                   },
  //                 ),
  //                 TextButton(
  //                   child: Text(
  //                     'لا',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                 )
  //               ],
  //             ),
  //           ));
  // }
  //
  // void _showFinishedDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
  //             child: AlertDialog(
  //               backgroundColor: Colors.black45,
  //               title: Text(
  //                 "هل انت متأكد من تحويل الدردشة لشخص اخر؟",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: Text(
  //                     'تحويل',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                   onPressed: () async {
  //                     final result = await AuthHelper.authHelper
  //                         .transferDream(int.tryParse(dreamId.toString()));
  //                     if (result != null && result == true) {
  //                       firestore.collection('chat').doc(widget.id).update({
  //                         'isFinished': true,
  //                       });
  //                       // firestore.collection('chat').doc(widget.id).update({
  //                       //   'allDone': true,
  //                       // });
  //                       // setState(() {
  //                       isFinished = true;
  //                       // });
  //                     }
  //                     Navigator.of(ctx).pop();
  //                   },
  //                 ),
  //                 TextButton(
  //                   child: Text(
  //                     'لا',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                 )
  //               ],
  //             ),
  //           ));
  // }

  void showDateExplained(String date) {
    showDialog(
        context: context,
        builder: (ctx) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                backgroundColor: Colors.black45,
                title: Text(
                  "تم تفسير الحلم فى $date",
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'رجوع',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final result = await AuthHelper.authHelper.endDreams(
                          int.tryParse(dreamId.toString())!, widget.id);
                      if (result != null && result == true) {
                        // firestore.collection('chat').doc(widget.id).update({
                        //   'isFinished': true,
                        //   'allDone': true,
                        // });
                        // setState(() {
                        isFinished = true;
                        isDone = true;
                        // });
                      }
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }

  final firestore = FirebaseFirestore.instance;
  bool isFinished = false;

  void getData(phone) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    //
    // final ref =
    //     FirebaseFirestore.instance.collection('users').get().then((value) {
    //   print('ex ::::: ${widget.name}');
    //   print('ex ::::: ${value.docs.first.data().toString()}');
    //
    //   userToken = value.docs
    //       .firstWhere((element) => element.data()['phone'] == widget.name)
    //       .data()['tokens'];
    //   print('::::::::::::::::::::::::::::::${userToken.toString()}');
    // });

    await  FirebaseDatabase.instance.ref("users").child("Token").child(phone).get().then(( value) {
      Map<dynamic,dynamic>?ff=value.value as Map?;
      userToken=ff!['token'];
      print("dsaw${userToken}");

    });
  }

  Future<void> _onFileUploadButtonPressed(String _filePath) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      isSending = true;
    });
    try {
      String fileName =
          _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length);
      await firebaseStorage
          .ref('voices')
          .child(fileName)
          .putFile(File(_filePath));
      _enterMassage = 'voices/$fileName';
      await _sendMassage();
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  //  getData();
    isDone = widget.dreamFinished;
  }

  _sendMassage() async {
    setState(() {
      isSending = true;
    });
    messages!.add({
      'text': _enterMassage,
      'createdAt': Timestamp.now(),
      'senderId': AuthHelper.authHelper.theUser.id
    });
    var data = await FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.id)
        .update({
      'lastMessage': {
        'msg': _enterMassage.contains('voice') ? 'مقطع صوتى' : _enterMassage,
        'timeSent': DateTime.now().toUtc(),
        'fromExplainer': true,
      },
      'messages': messages,
    });
    _controller.clear();
    setState(() {
      isSending = false;
    });
    try {
      // FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'sendMsg',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 10),
        ),
      );
      callable.call({
        'tokens': userToken,
        'title': 'رساله جديده',
        'body': _enterMassage.contains('voice') ? 'مقطع صوتى' : _enterMassage,
        'extraData': {
          'route': 'chat',
          'id': widget.id,
          'name': AuthHelper.authHelper.theUser.name,
          'dreamText': widget.dream,
        }
      });
    } catch (e) {
      setState(() {
        isSending = false;
      });
      print('Error sending fcm :: ${e.toString()}');
    }
    // print();
    // .update(
    //   {
    //     'text': _enterMassage,
    //     'createAt': Timestamp.now(),
    //     'user': FirebaseAuth.instance.currentUser.phoneNumber,
    //     'senderId': FirebaseAuth.instance.currentUser.uid
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    print('chat screen id ${widget.id}');

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator()); // or handle no data case
          }

          final docs = snapshot.data as DocumentSnapshot<Map<String, dynamic>>;

          if (docs == null || docs['messages'] == null || docs['dreamId'] == null) {
            return Center(child: CircularProgressIndicator()); // or handle missing data case
          }
          List<dynamic> msgs = docs['messages'] ;
          dreamId = docs['dreamId'];
          print('::::::::::::::::::::::::::::::::::: ${dreamId}');

          print(docs['Id']);
          print('hnaaa ${widget.id}');
          length = docs['messages'].length;
          messages = docs['messages'];
          isFinished = docs['isFinished'] ?? false;
          isDone = docs['allDone'] ?? false;
          dateExplained = docs['dateExplained'] ?? '';
          deletedMap = docs['deleted'];

          getData(docs['userNumber']);
          return Scaffold(
            backgroundColor: Color(0xffF2EEE8),
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: AppBar().preferredSize.height,
                  width: AppBar().preferredSize.width,
                  padding: Helper.defaultPadding,
                  decoration: BoxDecoration(
                      boxShadow: AppShadow.shadow036, color: Colors.white),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          )),
                      // CustomText(
                      //   '297',
                      //   fontSize: 14,
                      //   color: AppColors.primaryColor,
                      //   fontWeight: FontWeight.w600,
                      //   height: 1.5.h,
                      // ),
                      SizedBox(
                        width: 12.9.w,
                      ),
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/appLogo.jpeg',
                            width: 36.67,
                            height: 36.67,
                            fit: BoxFit.cover,
                          ),
                          // Positioned(
                          //   bottom: 0,
                          //   left: 0,
                          //   child: Container(
                          //     height: 8.8.h,
                          //     width: 8.8.w,
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: Color(0xff08BC08),
                          //       border:
                          //           Border.all(width: 1.0.w, color: Colors.white),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        width: 8.4.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            widget.name != null && widget.name.length > 8
                                ? widget.name.substring(0, 7) + '****'
                                : 'غير معروف',
                            fontSize: 14,
                            color: AppColors.textColor2,
                            fontWeight: FontWeight.w700,
                            height: 1.6.h,
                          ),
                          // CustomText(
                          //   'أونلاين',
                          //   fontSize: 10,
                          //   color: Color(0xff918f8f),
                          //   height: 1.6.h,
                          // ),
                        ],
                      ),
                      Spacer(),
                      if (!isFinished && !isDone)
                        IconButton(
                          onPressed: () {
                            final timeStamp =
                                messages!.first['createdAt'] as Timestamp;
                            var createdDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    timeStamp.millisecondsSinceEpoch);
                            print(
                                '::::::::::::::::::' + createdDate.toString());
                            final finishedDuration =
                                DateTime.now().difference(createdDate);
                            Navigator.pop(context);
                            firestore.collection('chat').doc(widget.id).update({
                              'dateExplained': '${finishedDuration.inMinutes}',
                            });
                            showDateExplained(
                                '${finishedDuration.inMinutes} دقيقه ');
                          },
                          icon: Icon(
                            Icons.done_all,
                            color: Colors.black,
                            size: 24.0,
                          ),
                        ),
                      // DropdownButton<String>(
                      //   items: <String>[
                      //     'تحويل الدردشه',
                      //     'تم التفسير',
                      //     // 'انهاء الدردشة',
                      //   ].map((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: TextButton.icon(
                      //         icon: (value == 'تحويل الدردشه')
                      //             ? Icon(Icons.assistant_direction,
                      //                 color: Colors.grey)
                      //             : (value == 'تم التفسير')
                      //                 ? Icon(Icons.check, color: Colors.grey)
                      //                 : Icon(Icons.clear, color: Colors.grey),
                      //         label: Text(
                      //           value,
                      //           style: TextStyle(color: Colors.grey),
                      //         ),
                      //         onPressed: () async {
                      //           if (value == 'تحويل الدردشه') {
                      //             Navigator.pop(context);
                      //             _showFinishedDialog();
                      //           } else if (value == 'تم التفسير') {
                      //             final timeStamp = messages
                      //                 .first['createdAt'] as Timestamp;
                      //             var createdDate =
                      //                 DateTime.fromMillisecondsSinceEpoch(
                      //                     timeStamp.millisecondsSinceEpoch);
                      //             print('::::::::::::::::::' +
                      //                 createdDate.toString());
                      //             final finishedDuration =
                      //                 DateTime.now().difference(createdDate);
                      //             Navigator.pop(context);
                      //             firestore
                      //                 .collection('chat')
                      //                 .doc(widget.id)
                      //                 .update({
                      //               'dateExplained':
                      //                   '${finishedDuration.inMinutes}',
                      //             });
                      //             showDateExplained(
                      //                 '${finishedDuration.inMinutes} دقيقه ');
                      //           }
                      //           // else {
                      //           //   Navigator.pop(context);
                      //           //   _showErrorDialog();
                      //           // }
                      //         },
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (_) {},
                      //   icon: Icon(Icons.more_vert_rounded),
                      //   underline: Text(''),
                      // ),
                      // IconButton(icon:Icon(Icons.clear),color: Colors.red,onPressed: (){
                      //   _showErrorDialog();
                      // },)
                    ],
                  ),
                ),
                if (widget.dream != null && widget.dream.isNotEmpty)
                  ExpansionTile(
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    title: CustomText(
                      'تفاصيل الحلم',
                      fontSize: 14,
                      color: AppColors.textColor2,
                      fontWeight: FontWeight.w700,
                      height: 1.6.h,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          widget.dream,
                          fontSize: 15,
                          color: AppColors.textColor2,
                          fontWeight: FontWeight.w500,
                          height: 1.5.h,
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: ListView(
                    reverse: true,
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                    children: [
                      if (msgs != null && msgs.isNotEmpty)
                        ...msgs
                            .map((e) => InChatItem(
                                  message: e['text'],
                                  date: e['createdAt'],
                                  inLeft: e['senderId'] ==
                                          AuthHelper.authHelper.theUser.id
                                      ? true
                                      : false,
                                ))
                            .toList()
                      else
                        SizedBox.shrink(),
                    ].reversed.toList(),
                  ),
                ),
                Container(
                  height: 70.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Color(0xfff5f7f6),
                  ),
                  child: isDone
                      ? const Center(
                          child: Text('تم التفسير'),
                        )
                      : isFinished
                          ? const Center(
                              child: Text('لا يمكنك الرد على الدردشه'),
                            )
                          : isRecording
                              ? RecorderView(
                                  onSaved: (recording) async {
                                    setState(() {
                                      isRecording = false;
                                    });
                                    if (recording?.path != null)
                                      await _onFileUploadButtonPressed(
                                          (recording!.path).toString());
                                  },
                                )
                              : Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isRecording = true;
                                        });
                                      },
                                      child: Icon(
                                        Icons.mic_none,
                                        size: 30.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 11.w,
                                    ),

                                    Expanded(
                                      child: Container(
                                        // width: 280.w,
                                        height: 38.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0.r),
                                            color: Colors.white),
                                        child: TextFormField(
                                          controller: _controller,
                                          onEditingComplete: () {
                                            setState(() {});
                                          },

                                          style: TextStyle(
                                              color: AppColors.textBlack,
                                              fontSize: 16.sp,
                                              fontFamily: "Cairo",
                                              fontWeight: FontWeight.w700),

                                          textAlign: TextAlign.start,
                                          onChanged: (val) async {
                                            _enterMassage = val;
                                          },
                                          // validator: ,
                                          //  onSaved: ,
                                          //    onChanged: ,
                                          cursorColor: Colors.grey,

                                          decoration: buildInputDecorationA(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    isSending
                                        ? CupertinoActivityIndicator()
                                        : InkWell(
                                            onTap: () {
                                              if (_enterMassage
                                                      .trim()
                                                      .isNotEmpty &&
                                                  !isSending) _sendMassage();
                                              // setState(() {
                                              //   _enterMassage.trim().isEmpty ? null : _sendMassage();
                                              // });
                                            },
                                            child: CustomSvgImage(
                                              imageName: 'send',
                                              width: 21,
                                              height: 18,
                                            ),
                                          ),
                                    // InkWell(
                                    //   onTap: _enterMassage.trim().isEmpty ? null : _sendMassage(),
                                    //   child: CustomSvgImage(
                                    //     imageName: 'send',
                                    //     width: 21,
                                    //     height: 18,
                                    //   ),
                                    // ),
                                  ],
                                ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  InputDecoration buildInputDecorationA() {
    return InputDecoration(
      filled: false,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      hintText: 'كتابة رسالة ...',
      hintStyle: TextStyle(
        fontSize: 12.sp,
        color: AppColors.subTextBlack,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0.r),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0.r),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0.r),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1.0.w,
        ),
      ),
    );
  }
}
