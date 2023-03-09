import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? requiredFieldEmail(String? valueEm) {
  if (valueEm == null || valueEm.isEmpty) {
    return 'This field email can not be empty';
  }
  return null;
}

String? requiredFieldPhoneNumber(String? valuePn) {
  if (valuePn == null || valuePn.isEmpty) {
    return 'This field phone number can not be empty';
  }
  return null;
}

String? requiredFieldUserName(String? valueUn) {
  if (valueUn == null || valueUn.isEmpty) {
    return 'This field user name can not be empty';
  }
  return null;
}

String? requiredFieldPassword(String? valueP) {
  if (valueP == null || valueP.isEmpty) {
    return 'This field password can not be empty';
  }
  return null;
}

class UtilSharedPreferences {
  static Future<String> getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('token') ?? '';
  }

  static Future setToken(String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('token', value);
  }
}
