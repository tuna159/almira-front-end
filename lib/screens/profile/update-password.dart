import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/utils/utils.dart' as utils;

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _updatePassword() async {
    // final currentUser = FirebaseAuth.instance.currentUser;

    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      // Display an error message if the new passwords don't match.
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    await ApiUserService()
        .updatePassword(oldPassword, confirmPassword)
        .then((value) async {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successful update password')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        backgroundColor: defaultColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                controller: _oldPasswordController,
                validator: utils.requiredFieldPassword,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                  ),
                  labelText: 'Old password',
                  labelStyle: TextStyle(
                      fontFamily: 'OpenSansMedium',
                      color: Color.fromARGB(255, 97, 95, 95)),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                controller: _newPasswordController,
                validator: utils.requiredFieldPassword,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                  ),
                  labelText: 'New password',
                  labelStyle: TextStyle(
                      fontFamily: 'OpenSansMedium',
                      color: Color.fromARGB(255, 97, 95, 95)),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field password can not be empty';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Need to enter the correct password';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 97, 95, 95)),
                  ),
                  labelText: 'Confirm password',
                  labelStyle: TextStyle(
                      fontFamily: 'OpenSansMedium',
                      color: Color.fromARGB(255, 97, 95, 95)),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updatePassword();
                  }
                },
                child: Text('Update Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
