import 'dart:convert';
import 'dart:io';

import 'package:almira_front_end/utils/utils.dart';
import 'package:http/http.dart' as http;

class ApiPostCommentService {
  final String baseUrl = "http://192.168.1.145:3009";

  Future getPostComment(int postId) async {
    String token = await getTokenFromSF();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/post/$postId/comments'),
      headers: headers,
    );
    var responseBody = jsonDecode(response.body);

    if (responseBody['status_code'] == 200) {
      return responseBody["data"];
    } else {
      throw responseBody["error_message"];
    }
  }

  Future addCommentToPost(int postId, String content) async {
    String token = await getTokenFromSF();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    Map<String, String> body = {'content': content};

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/post/$postId/comments'),
      headers: headers,
      body: jsonEncode(body),
    );
    var responseBody = jsonDecode(response.body);

    if (responseBody['status_code'] == 200) {
      return responseBody;
    } else {
      throw responseBody["error_message"];
    }
  }
}
