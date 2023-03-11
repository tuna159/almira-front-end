import 'package:almira_front_end/screens/home/add_post_screen.dart';
import 'package:almira_front_end/screens/home/home-app.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/screens/home/search_screen.dart';
import 'package:almira_front_end/screens/welcome-app/login.dart';
import 'package:flutter/material.dart';

List<Widget> homeScreenItems = [
  const HomeApp(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  const ProfileScreen(),
];
