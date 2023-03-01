import 'dart:convert';
import 'dart:io';

import 'package:almira_front_end/helper/utils.dart';
import 'package:almira_front_end/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiPostService {
  final String baseUrl = "http://192.168.1.59:3009";

  Future getPost() async {
    String token = await UtilSharedPreferences.getToken();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/post'),
      headers: headers,
    );
    var responseBody = jsonDecode(response.body);

    if (responseBody['status_code'] == 200) {
      // return responseBody;

      Map<String, dynamic> data = responseBody;
      return data;
    } else {
      throw jsonDecode(response.body)["error_message"];
    }
  }

  Future likePost(int id) async {
    String token = await UtilSharedPreferences.getToken();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/post/$id/likes'),
      headers: headers,
    );

    var responseBody = jsonDecode(response.body);
    if (responseBody['status_code'] == 200) {
      return responseBody;
    } else {
      throw responseBody["error_message"];
    }
  }
}
