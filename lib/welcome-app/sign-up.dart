// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:math';

import 'package:almira_front_end/api/api-user/api-user-service.dart';
import 'package:almira_front_end/model/user.dart';
import 'package:almira_front_end/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:almira_front_end/helper/utils.dart' as utils;

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ApiUserService _apiUserService = ApiUserService();

  bool _isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: utils.defaulColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'OpenSansMedium'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: utils.requiredFieldEmail,
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 97, 95, 95)),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSansMedium',
                            color: Color.fromARGB(255, 97, 95, 95)),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: utils.requiredFieldPhoneNumber,
                      controller: phoneNumberController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 97, 95, 95)),
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
                      validator: utils.requiredFieldUserName,
                      controller: userNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 97, 95, 95)),
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
                      validator: utils.requiredFieldPassword,
                      obscureText: true,
                      controller: passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 97, 95, 95)),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field password can not be empty';
                        }
                        if (value != passwordController.text) {
                          return 'Need to enter the correct password';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 97, 95, 95)),
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
                          style: TextStyle(
                              fontSize: 12, fontFamily: 'OpenSanssBold'),
                        ),
                        onPressed: () {
                          sigup();
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Does have account?',
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'OpenSansMedium'),
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
                          sigup();
                          //signup screen
                        },
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  //

  void sigup() async {
    // final String baseUrl = "http://192.168.1.145:3009";
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String phone = phoneNumberController.text;
      String userName = userNameController.text;
      String password = passwordController.text;

      _apiUserService.signUp(email, phone, userName, password).then((user) {
        Navigator.pushNamed(context, RouteNames.HomeApp);
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }

    //   Future<void> showMyDialogCheckInput() async {
    //     return showDialog<void>(
    //       context: context,
    //       barrierDismissible: false, // user must tap button!
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: const Text('Confirm New Trip'),
    //           // ignore: prefer_interpolation_to_compose_strings
    //           content: Text('Detail Trip '),
    //           actions: <Widget>[
    //             TextButton(
    //               child: const Text('No'),
    //               onPressed: (() {
    //                 Navigator.pop(context);
    //               }),
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   }
  }
}
