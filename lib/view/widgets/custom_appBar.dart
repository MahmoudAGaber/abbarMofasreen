import 'package:flutter/material.dart';
import 'package:dream2/my_library.dart';

import '../../server/app_provider.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool destroy;
  final bool withBack ;
  final bool centerTitle ;
  CustomAppBar({required this.title, this.withBack = false, this.centerTitle = false, this.destroy=false });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: withBack?true:centerTitle,
      elevation: 0,
      leadingWidth: withBack?null:0,
      leading: Visibility(
        visible: withBack,
        child: IconButton(
            onPressed: () {

              if(this.destroy)
                {
                  Get.close(0) ;
              //    AppProvider().setIndexScreen(2);
                }
              else{
                Get.back();
              }

            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      title: CustomText(
        title?? 'فسر حلمك',
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
