import 'package:almira_front_end/home/home-app.dart';
import 'package:almira_front_end/routes/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ApplicationNetWork());

class ApplicationNetWork extends StatelessWidget {
  const ApplicationNetWork({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouteNames.HomeApp: (context) => const HomeApp(),
      },
      initialRoute: RouteNames.HomeApp,
      // home: Welcome(),
    );
  }
}
