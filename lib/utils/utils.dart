import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? requiredFieldEmail(String? valueEm) {
  if (valueEm == null || valueEm.isEmpty) {
    return 'This field email can not be empty';
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

String? requiredFieldPhoneNumber(String? valueP) {
  if (valueP == null || valueP.isEmpty) {
    return 'This field phone number can not be empty';
  }
  return null;
}

addTokenToSF(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
}

getTokenFromSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tokenValue = prefs.getString('token');
  return tokenValue;
}

Future<String> decrypToken1(String token) {
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return payload["user_id"];
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

decrypToken(String token) {
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return payload["user_id"];
}
