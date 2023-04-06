import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/screens/forgot-password/reset-password.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class InputOtp extends StatefulWidget {
  final phoneNumber;
  const InputOtp({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<InputOtp> createState() => _InputOtpState();
}

class _InputOtpState extends State<InputOtp> {
  ApiUserService _apiUserService = ApiUserService();

  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final phoneNumber = widget.phoneNumber;
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Input '),
        backgroundColor: defaultColor,
      ),
      body: Column(children: [
        Text(
            ('OTP code has been sent to your phone number : $phoneNumber, please check  '),
            style: TextStyle(fontSize: 24, fontFamily: 'OpenSansMedium')),
        SizedBox(
          height: 20,
        ),
        Center(
          child: PinCodeTextField(
            length: 5,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              borderRadius: BorderRadius.circular(5),
              activeFillColor: Colors.transparent,
            ),
            animationDuration: Duration(milliseconds: 300),
            controller: otpController,
            keyboardType: TextInputType.number,
            onChanged: (value) {},
            onCompleted: (value) {},
            appContext: context,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSanssBold'),
              ),
              onPressed: verifyPassword,
            )),
      ]),
    );
  }

  void verifyPassword() {
    int otp = int.parse(otpController.text);

    _apiUserService.verifyPassword(otp).then((user) async {
      print(user);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordConfirmPage(uid: user["user_id"]),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }
}
