import 'package:almira_front_end/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/helper/utils.dart' as utils;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: utils.defaulColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Almira',
                    style: TextStyle(fontSize: 32, fontFamily: 'BMDANIEL'),
                  )),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 20, fontFamily: 'OpenSansMedium'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          fontFamily: 'OpenSansMedium',
                          color: Color.fromARGB(255, 97, 95, 95))),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                      ),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                          fontFamily: 'OpenSansMedium',
                          color: Color.fromARGB(255, 97, 95, 95))),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                      ),
                      labelText: 'User Name',
                      labelStyle: TextStyle(
                          fontFamily: 'OpenSansMedium',
                          color: Color.fromARGB(255, 97, 95, 95))),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  // controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        fontFamily: 'OpenSansMedium',
                        color: Color.fromARGB(255, 97, 95, 95)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  // controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                    ),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                        fontFamily: 'OpenSansMedium',
                        color: Color.fromARGB(255, 97, 95, 95)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: utils.defaulColor,
                    ),
                    child: const Text(
                      'Sign up',
                      style:
                          TextStyle(fontSize: 12, fontFamily: 'OpenSanssBold'),
                    ),
                    onPressed: () {
                      // print(userNameController.text);
                      // print(passwordController.text);
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Does have account?',
                    style:
                        TextStyle(fontSize: 14, fontFamily: 'OpenSansMedium'),
                  ),
                  TextButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSansMedium',
                          color: Color.fromARGB(255, 4, 191, 182)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.Login);
                      //signup screen
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
