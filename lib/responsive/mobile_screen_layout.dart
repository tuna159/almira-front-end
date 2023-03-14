import 'package:almira_front_end/screens/home/add_post_screen.dart';
import 'package:almira_front_end/screens/home/home-app.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/screens/home/search_screen.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/global_variable.dart';
import 'package:almira_front_end/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  final String token;
  const MobileScreenLayout({Key? key, required this.token}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  // Future<String> getToken() async {
  //   var token = await fetchGetToken();
  //   // print(order);
  //   var uid = decrypToken(token);
  //   return uid;
  // }

  // Future<String> fetchGetToken() {
  //   // Imagine that this function is more complex and slow.
  //   return Future.delayed(const Duration(seconds: 0),
  //       () async => await UtilSharedPreferences.getToken());
  // }

  // main() async {
  //   String uid = await getToken();
  //   return uid;
  // }

  @override
  Widget build(BuildContext context) {
    var uid = decrypToken(widget.token);

    return Scaffold(
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            const HomeApp(),
            const SearchScreen(),
            const AddPostScreen(),
            const Text('notifications'),
            ProfileScreen(uid: uid),
          ]),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: defaultColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? primaryColor : defaultBTColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_page == 1) ? primaryColor : defaultBTColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: (_page == 2) ? primaryColor : defaultBTColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: (_page == 3) ? primaryColor : defaultBTColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (_page == 4) ? primaryColor : defaultBTColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
