import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/utils/utils.dart' as utils;

class ResetPasswordConfirmPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final uid;
  ResetPasswordConfirmPage({Key? key, required this.uid}) : super(key: key);

  @override
  _ResetPasswordConfirmPageState createState() =>
      _ResetPasswordConfirmPageState();
}

class _ResetPasswordConfirmPageState extends State<ResetPasswordConfirmPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  ApiUserService _apiUserService = ApiUserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: defaultColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(('Input and reset password'),
                  style: TextStyle(fontSize: 26, fontFamily: 'OpenSansMedium')),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  validator: utils.requiredFieldPassword,
                  obscureText: true,
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                    ),
                    labelText: 'New Password',
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
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field password can not be empty';
                    }
                    if (value != _passwordController.text) {
                      return 'Need to enter the correct password';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                    ),
                    labelText: 'Enter confirm password',
                    labelStyle: TextStyle(
                        fontFamily: 'OpenSansMedium',
                        color: Color.fromARGB(255, 97, 95, 95)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultColor,
                    ),
                    child: const Text(
                      'Reset Password',
                      style:
                          TextStyle(fontSize: 12, fontFamily: 'OpenSanssBold'),
                    ),
                    onPressed: resetPassword,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword() {
    if (_formKey.currentState!.validate()) {
      String password = _confirmPasswordController.text;

      _apiUserService.resetPassword(widget.uid, password).then((user) async {
        showSnackBar(
          this.context,
          'Change password sucessfully!',
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }
  }
}
