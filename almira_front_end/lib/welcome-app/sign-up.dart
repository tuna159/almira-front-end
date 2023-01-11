import 'package:almira_front_end/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/helper/utils.dart' as utils;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // late FocusNode myFocusNode;

  // final _lowColor = Colors.amber[50]; // use your own colors
  // final _highColor = Colors.amber[200];

  // Color _field1Color = utils.defaulColor;
  // Color _field2Color = _lowColor;

  // @override
  // void initState() {
  //   super.initState();

  //   myFocusNode = FocusNode();
  // }

  // @override
  // void dispose() {
  //   // Clean up the focus node when the Form is disposed.
  //   myFocusNode.dispose();

  //   super.dispose();
  // }

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
                    'Sign in',
                    style:
                        TextStyle(fontSize: 20, fontFamily: 'OpenSansMedium'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  // child: Focus(
                  //   onFocusChange: (hasFocus) {
                  //     setState(() => _field1Color =
                  //         hasFocus ? Colors.amber : Colors.amber);
                  //   },
                  child: TextFormField(
                    controller: userNameController,
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
                    obscureText: true,
                    controller: passwordController,
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
                TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 4, 191, 182),
                        fontFamily: 'OpenSansMedium'),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: utils.defaulColor,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 12, fontFamily: 'OpenSanssBold'),
                      ),
                      onPressed: () {
                        print(userNameController.text);
                        print(passwordController.text);
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Does not have account?',
                      style:
                          TextStyle(fontSize: 14, fontFamily: 'OpenSansMedium'),
                    ),
                    TextButton(
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'OpenSansMedium',
                            color: Color.fromARGB(255, 4, 191, 182)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.Register);
                        //signup screen
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
