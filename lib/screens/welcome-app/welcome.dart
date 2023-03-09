import 'package:almira_front_end/routes/routes.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/utils/utils.dart' as utils;

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(Object context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          child: Stack(
            children: <Widget>[
              const Positioned(
                top: 300,
                left: -176,
                height: 750,
                width: 750,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                ),
              ),
              const Positioned(
                top: 120,
                left: 74,
                height: 250,
                width: 250,
                child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/background.png')),
              ),
              Positioned(
                bottom: 220,
                left: 75,
                child: Container(
                  height: MediaQuery.of(this.context).size.height * 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Almira  ', style: progressHeaderStyle),
                      const Text('A place for dogs and cats',
                          style: TextStyle(
                              fontSize: 22, fontFamily: 'OpenSansMedium')),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: 0.95,
                          backgroundColor:
                              const Color(0xfffbfaff).withOpacity(0.6),
                          valueColor: const AlwaysStoppedAnimation(
                              Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        children: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              minimumSize: const Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  this.context, RouteNames.Login);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'OpenSansMedium',
                                fontSize: 22,
                                color: Color(0xffffffff),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              minimumSize: const Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  this.context, RouteNames.SignUp);
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontFamily: 'OpenSansMedium',
                                fontSize: 22,
                                color: Color(0xffffffff),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
