import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream2/my_library.dart';
import 'package:dream2/view/auth/auth_helper.dart';
import '../screens/chat_screen.dart';
import '../widgets/out_chat_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllChatScreen extends StatefulWidget {
  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  bool isloading = false;

  var firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> allChats = [];
  Map<String, dynamic> deletedMap = {};

  Future<void> getChats(chats , context) async {
    final fire = firestore.collection('chat');
    final collection = await fire.get();
    allChats.clear();
    for (var i = 0; i < chats.length; i++) {
      try {
        collection.docs.forEach((element) {
          print(chats[i] + '+' + element["Id"]);
          if (chats[i] == element["Id"]&&element["isFinished"]==false ) {
            print(element['explainerName']);
            final Timestamp timestamp =
                element['lastMessage']['timeSent'] as Timestamp;
            final DateTime dateTime = timestamp.toDate();
            deletedMap = element['deleted'];
            if (!deletedMap['explainer']) {
              allChats.add({
                'id': element['Id'],
                'num': element['userNumber'],
                'lastMsg': element['lastMessage'],
                'dateTime': dateTime,
                'dreamText': element['dreamText'] ?? 'تفاصيل الحلم غير واضحه',
                'allDone': element['allDone'] ?? false,
              });
            }
            allChats.sort((x, y) => y['dateTime'].compareTo(x['dateTime']));
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void deleteChat(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: Colors.black45,
          title: Text(
            "هل تريد حذف الدردشه؟",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'رجوع',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text(
                'نعم',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  deletedMap['explainer'] = true;
                  FirebaseFirestore.instance
                      .collection('chat')
                      .doc(id)
                      .update({'deleted': deletedMap});
                });
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Helper.myPreferredSize,
          child: CustomAppBar(
            title: 'الدردشات',
            withBack: false,
          )),
      body:
          //  isloading
          //     ? Center(
          //         child: CircularProgressIndicator(),
          //       )
          // Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //       CustomSvgImage(
          //         imageName: 'no-comment',
          //         height: 141.33,
          //         width: 141.33,
          //       ),
          //       SizedBox(
          //         height: 17.3.h,
          //       ),
          //       CustomText(
          //         'لا يوجد دردشات قم بالتواصل \nمع مفسرين الأحلام',
          //         fontSize: 20,
          //         color: AppColors.textColor1,
          //         fontWeight: FontWeight.w600,
          //         height: 1.55.h,
          //         textAlign: TextAlign.center,
          //       )
          //     ],
          //   )
          // :
          FadeInUp(
        duration: Duration(milliseconds: 500 + 100),
        controller: (AnimationController ) {  },
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat').where('providerId',isEqualTo: AuthHelper.authHelper.theUser.id).where('allDone',isEqualTo: false).where('isFinished',isEqualTo: false)

                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }



              // getChats(chatDocs, ctx);
              return chatSnapshot.data!.docs.isEmpty ? Center(
              child: CustomText(
              'لا يوجد دردشات',
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              ),
              )
                  : ListView.builder(
              reverse: false,
              itemCount: chatSnapshot.data!.docs.length,
              itemBuilder: (ctx, index) => OutChatItem(
              name: chatSnapshot.data!.docs[index]['userNumber'],
              id:chatSnapshot.data!.docs[index]['Id'],
              date:( chatSnapshot.data!.docs[index]['lastMessage']['timeSent'] as Timestamp).toDate(),
              imageUrl: 'assets/images/appLogo.jpeg',
              // message: 'نعم لدي خبرة ممتاز في تفسير الاحلام يقدع',
              lastMessage:chatSnapshot.data!.docs[index]['lastMessage']
              ['msg'],
              numOfMessage: 33.toString(),
              newMessage: false,
              onLongPress: () => deleteChat(
              context,
                chatSnapshot.data!.docs[index]['Id'],
              ),
              onTap: () {
                //print("Hellllllllllllllllo${chatSnapshot.data!.docs[index]['Id']}");
                if(chatSnapshot.data!.docs[index]['Id'] == ""){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("لم تعد المحادثه متوفره الان ..."),duration: Duration(seconds: 1),));
                  print("Document not found");
                }else {
                  Get.to(
                          () => ChatScreen(
                        chatSnapshot.data!.docs[index]['Id'],
                        chatSnapshot.data!.docs[index]['userNumber'],
                        chatSnapshot.data!.docs[index]['dreamText'] ?? 'تفاصيل الحلم غير واضحه',
                        dreamFinished:   chatSnapshot.data!.docs[index]
                        ['allDone'] ??
                            false,
                      ),
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 500),
                      transition: Transition.fadeIn);
                }

              },
              ),
              );
            }),
      ),
    );
  }
}
