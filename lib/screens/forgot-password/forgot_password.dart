import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/screens/forgot-password/input_otp.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/utils/utils.dart' as utils;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  ApiUserService _apiUserService = ApiUserService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: defaultColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                  "Please enter your phone number to reset your password",
                  style: TextStyle(fontSize: 28, fontFamily: 'OpenSansMedium')),
              const SizedBox(
                height: 20,
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
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                      ),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                          fontFamily: 'OpenSansMedium',
                          color: Color.fromARGB(255, 97, 95, 95))),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultColor,
                    ),
                    child: const Text(
                      'Next',
                      style:
                          TextStyle(fontSize: 12, fontFamily: 'OpenSanssBold'),
                    ),
                    onPressed: forgotPassword,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void forgotPassword() {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = phoneNumberController.text;

      _apiUserService.forgotPassword(phoneNumber).then((user) async {
        print(user);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InputOtp(phoneNumber: user),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }
  }
}
