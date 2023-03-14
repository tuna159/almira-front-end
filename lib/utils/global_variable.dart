import 'package:almira_front_end/screens/home/add_post_screen.dart';
import 'package:almira_front_end/screens/home/home-app.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/screens/home/search_screen.dart';
import 'package:almira_front_end/utils/utils.dart';
import 'package:flutter/material.dart';

getToken() async {
  String token = await getTokenFromSF();
  return token;
}

Future<String> get check async {
  String token = await getTokenFromSF();
  return decrypToken(token);
}

List<Widget> homeScreenItems = [
  const HomeApp(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(uid: check.toString()),
];
