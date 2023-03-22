import 'dart:convert';
import 'dart:io';

import 'package:almira_front_end/utils/utils.dart';
import 'package:almira_front_end/model/user.dart';
import 'package:http/http.dart' as http;

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
      await addTokenToSF(token);
      return responseBody["data"];
    } else {
      throw responseBody["error_message"];
    }
  }

  Future<void> signUp(String email, String introduction, String userName,
      String password, String imageUrl) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, String> body = {
      'email': email,
      'username': userName,
      'password': password,
      'image_url': imageUrl,
      'introduction': introduction,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/signup'),
      headers: headers,
      body: jsonEncode(body),
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['status_code'] == 200) {
      Map<String, dynamic> data = responseBody;
      String token = data["data"]["token"];
      await addTokenToSF(token);
      return responseBody["data"];
    } else {
      throw responseBody["error_message"];
    }
  }

  Future getUserName(String search_key) async {
    String token = await getTokenFromSF();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/user/search?search_key=$search_key'),
      headers: headers,
    );
    var responseBody = jsonDecode(response.body);

    if (responseBody['status_code'] == 200) {
      return responseBody["data"];
    } else {
      throw responseBody["error_message"];
    }
  }

  Future getUserDetail(String uid) async {
    String token = await getTokenFromSF();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/user/$uid'),
      headers: headers,
    );
    var responseBody = jsonDecode(response.body);

    if (responseBody['status_code'] == 200) {
      Map<String, dynamic> data = responseBody;
      return data["data"];
    } else {
      throw responseBody["error_message"];
    }
  }

  Future followUser(String uid) async {
    String token = await getTokenFromSF();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/$uid/follow'),
      headers: headers,
    );
    var responseBody = jsonDecode(response.body);

    if (responseBody['status_code'] == 200) {
      Map<String, dynamic> data = responseBody;
      return data["data"];
    } else {
      throw responseBody["error_message"];
    }
  }

  Future unfollowUser(String uid) async {
    String token = await getTokenFromSF();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/user/$uid/unfollow'),
      headers: headers,
    );
    var responseBody = jsonDecode(response.body);

    if (responseBody['status_code'] == 200) {
      Map<String, dynamic> data = responseBody;
      return data["data"];
    } else {
      throw responseBody["error_message"];
    }
  }
}
