import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class ApiService {
  final String baseUrl = 'http://message-list.appspot.com/messages';

  Future<AuthorListResponse> fetchMessages({String? pageToken}) async {
    final url = pageToken != null ? '$baseUrl?pageToken=$pageToken' : baseUrl;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response. body);

      return AuthorListResponse.fromJson(data);
    } else {
      throw Exception('Failed to load messages');
    }
  }
}