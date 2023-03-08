import 'dart:convert';
import 'dart:io';

import 'package:almira_front_end/utils/utils.dart';
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
      return data["data"];
    } else {
      throw responseBody["error_message"];
    }
  }

  Future<void> likePost(int id, bool is_liked) async {
    String token = await UtilSharedPreferences.getToken();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    if (is_liked == false) {
      final responseLike = await http.post(
        Uri.parse('$baseUrl/api/v1/post/$id/likes'),
        headers: headers,
      );
      var responseBody = jsonDecode(responseLike.body);
      if (responseBody['status_code'] == 200) {
        return responseBody;
      } else {
        throw responseBody["error_message"];
      }
    } else if (is_liked == true) {
      final responseLike = await http.delete(
        Uri.parse('$baseUrl/api/v1/post/$id/likes'),
        headers: headers,
      );
      var responseBody = jsonDecode(responseLike.body);
      if (responseBody['status_code'] == 200) {
        return responseBody;
      } else {
        throw responseBody["error_message"];
      }
    }
  }

  Future deletePost(int id) async {
    String token = await UtilSharedPreferences.getToken();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/post/$id'),
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
