import 'package:almira_front_end/screens/comments_screen.dart';
import 'package:almira_front_end/screens/feed_screen.dart';
import 'package:almira_front_end/screens/home/home-app.dart';
import 'package:almira_front_end/routes/routes.dart';
import 'package:almira_front_end/screens/welcome-app/login.dart';
import 'package:almira_front_end/screens/welcome-app/sign-up.dart';
import 'package:almira_front_end/screens/welcome-app/welcome.dart';
import 'package:almira_front_end/widgets/post_card.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ApplicationNetWork());

class ApplicationNetWork extends StatelessWidget {
  const ApplicationNetWork({super.key});

  @override
  Widget build(BuildContext context) {
    // dotenv.load(fileName: ".env");
    return MaterialApp(
      routes: {
        RouteNames.Welcome: (context) => const Welcome(),
        RouteNames.HomeApp: (context) => const HomeApp(),
        RouteNames.Login: (context) => const Login(),
        RouteNames.SignUp: (context) => const SignUp(),
        // RouteNames.FeedScreen: (context) => const FeedScreen(),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.Login,
      // home: Welcome(),
    );
  }
}
