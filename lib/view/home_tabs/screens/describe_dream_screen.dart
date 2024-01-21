import 'package:dream2/models/argument.dart';
import 'package:dream2/my_library.dart';
import 'package:dream2/server/app_provider.dart';
import 'package:dream2/view/auth/auth_helper.dart';

import 'package:dream2/view/home_tabs/screens/write_dream_screen.dart';
import 'package:dream2/view/home_tabs/widgets/descripe_item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DescribeDreamScreen extends StatefulWidget {
  @override
  State<DescribeDreamScreen> createState() => _DescribeDreamScreenState();
}

class _DescribeDreamScreenState extends State<DescribeDreamScreen> {
  final ScrollController _scrollController = ScrollController();
  bool loading = false;
  bool refresh = false;

  Future<void> fetchData({int? start}) async {
    loading = true;
    // print(start ?? AuthHelper.authHelper.userDreams.length);
    await AuthHelper.authHelper.fetchDreams(
      refresh
          ? 0
          : Provider.of<AppProvider>(context, listen: false).userDreams.length,
      10,
      context,
    );
    loading = false;
    refresh = false;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        print("new data called");
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Helper.myPreferredSize,
          child: CustomAppBar(
            title: 'طلبات التفسير',
            centerTitle: true,
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            refresh = true;
          });
        },
        child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              return Consumer<AppProvider>(
                builder: (cyx, data, _) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      data.userDreams.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.userDreams == null ||
                      data.userDreams.isEmpty) {
                    return Center(
                      child: CustomText(
                        'لا يوجد احلام فى قاعده البيانات',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1.56.h,
                      ),
                    );
                  }
                  return ListView.separated(
                    controller: _scrollController,
                    padding:
                        EdgeInsets.only(top: 35.h, left: 16.w, right: 16.w),
                    physics: BouncingScrollPhysics(),
                    itemCount: data.userDreams.length,
                    itemBuilder: (context, index) {
                      return DescripeItem(
                        onTap: () => Get.to(
                            () => ReadDreamScreen(
                                  dreamDetails: ScreenArguments(
                                      data.userDreams[index], index + 1),
                                ),
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 500),
                            transition: Transition.fadeIn),
                        dreamBody: data.userDreams[index].description,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 16.h,
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
