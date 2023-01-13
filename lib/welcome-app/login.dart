import 'package:almira_front_end/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/helper/utils.dart' as utils;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
              key: _formKey,
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
                    'Login',
                    style:
                        TextStyle(fontSize: 20, fontFamily: 'OpenSansMedium'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: userNameController,
                    validator: utils.requiredField,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
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
                    validator: utils.requiredField,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: utils.defaulColor,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 12, fontFamily: 'OpenSanssBold'),
                      ),
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
                        'Sign up',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'OpenSansMedium',
                            color: Color.fromARGB(255, 4, 191, 182)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.SignUp);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void login() {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    print(userNameController.text);
    print(passwordController.text);

    Navigator.pushNamed(context, RouteNames.HomeApp);

    @override
    // ignore: unused_element
    void dispose() {
      userNameController.dispose();
      passwordController.dispose();

      super.dispose();
    }
  }
}
