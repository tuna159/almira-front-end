import 'package:almira_front_end/responsive/mobile_screen_layout.dart';
import 'package:almira_front_end/utils/global_variable.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ResponsiveLayout extends StatefulWidget {
  final String token;
  const ResponsiveLayout({Key? key, required this.token}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return MobileScreenLayout(token: widget.token);
    });
  }
}
