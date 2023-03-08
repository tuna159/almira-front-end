import 'dart:convert';

import 'package:almira_front_end/utils/utils.dart';
import 'package:almira_front_end/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiUserService {
  final String baseUrl = "http://192.168.1.156:3009";

  var token = "";

  Future<void> loginOTP(String username, String password) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, String> body = {'username': username, 'password': password};

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/login'),
      headers: headers,
      body: jsonEncode(body),
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['status_code'] == 200) {
      Map<String, dynamic> data = responseBody;
      String token = data["data"]["token"];
      UtilSharedPreferences.setToken(token);
      UserData.fromJson(responseBody);
    } else {
      throw responseBody["error_message"];
    }
  }

  Future<void> signUp(String email, String phoneNumber, String userName,
      String password) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, String> body = {
      'email_address': email,
      'phone_number': phoneNumber,
      'username': userName,
      'password': password
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/signup'),
      headers: headers,
      body: jsonEncode(body),
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['status_code'] == 200) {
      print(UserData.fromJson(responseBody));
      UserData.fromJson(responseBody);
    } else {
      throw responseBody["error_message"];
    }
  }
}
