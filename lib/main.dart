import 'package:almira_front_end/firebase_options.dart';

import 'package:almira_front_end/screens/home/home-app.dart';
import 'package:almira_front_end/routes/routes.dart';
import 'package:almira_front_end/screens/welcome-app/login.dart';
import 'package:almira_front_end/screens/welcome-app/sign-up.dart';
import 'package:almira_front_end/screens/welcome-app/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ApplicationNetWork());
}

class ApplicationNetWork extends StatelessWidget {
  const ApplicationNetWork({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouteNames.Welcome: (context) => const Welcome(),
        RouteNames.HomeApp: (context) => const HomeApp(),
        RouteNames.Login: (context) => const Login(),
        RouteNames.SignUp: (context) => const SignUp(),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.Welcome,
    );
  }
}
