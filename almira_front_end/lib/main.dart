import 'package:almira_front_end/home/home-app.dart';
import 'package:almira_front_end/routes/routes.dart';
import 'package:almira_front_end/welcome-app/register.dart';
import 'package:almira_front_end/welcome-app/sign-up.dart';
import 'package:almira_front_end/welcome-app/welcome.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ApplicationNetWork());

class ApplicationNetWork extends StatelessWidget {
  const ApplicationNetWork({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouteNames.Welcome: (context) => const Welcome(),
        RouteNames.HomeApp: (context) => const HomeApp(),
        RouteNames.SignUp: (context) => const SignUp(),
        RouteNames.Register: (context) => const Register(),
      },
      initialRoute: RouteNames.Welcome,
      // home: Welcome(),
    );
  }
}
