import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../exceptions/not_found_exception.dart';
import '../models/post_response.dart';
import 'auth_service.dart';

class HttpService {
  HttpService({
    required this.authService,
  });

  final AuthService authService;
  final http.Client client = http.Client();

  Future<T> get<T>(
      {required String url,
      required T Function(Map<String, dynamic>) fromJson}) async {
    final response = await client.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      final jsonData = convert.jsonDecode(response.body);

      return fromJson(jsonData);
    }
    if (response.statusCode == 404) {
      throw NotFoundException();
    }
    throw Exception("Unsupported status code ${response.statusCode}");
  }

  Future<List<T>> getList<T>(
      {required String url,
      required T Function(Map<String, dynamic>) fromJson}) async {
    final response = await client.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      final jsonData = convert.jsonDecode(response.body);

      return jsonData.map<T>((json) => fromJson(json)).toList();
    }
    if (response.statusCode == 404) {
      throw NotFoundException();
    }
    throw Exception("Unsupported status code ${response.statusCode}");
  }

  Future<T> secureGet<T>(
      {required String url,
      required T Function(Map<String, dynamic>) fromJson}) async {
    final authToken = await authService.getAuthToken();

    final response = await client.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    if (response.statusCode == 200) {
      final jsonData = convert.jsonDecode(response.body);

      return fromJson(jsonData);
    }
    if (response.statusCode == 404) {
      throw NotFoundException();
    }
    throw Exception("Unsupported status code ${response.statusCode}");
  }

  Future<List<T>> secureGetList<T>(
      {required String url,
      required T Function(Map<String, dynamic>) fromJson}) async {
    final authToken = await authService.getAuthToken();

    final response = await client.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    if (response.statusCode == 200) {
      final jsonData = convert.jsonDecode(response.body);

      return jsonData.map<T>((json) => fromJson(json)).toList();
    }
    if (response.statusCode == 404) {
      throw NotFoundException();
    }
    throw Exception("Unsupported status code ${response.statusCode}");
  }

  Future<PostResponse> securePost({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final authToken = await authService.getAuthToken();

    final response = await client
        .post(Uri.parse(url), body: convert.jsonEncode(body), headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      HttpHeaders.contentTypeHeader: "application/json"
    });
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = response.body.isNotEmpty
          ? convert.jsonDecode(response.body)
          : <String, dynamic>{};

      return PostResponse(statusCode: response.statusCode, data: jsonData);
    }
    if (response.statusCode == 404) {
      throw NotFoundException();
    }
    throw Exception("Unsupported status code ${response.statusCode}");
  }

  Future<PostResponse> secureDelete({
    required String url,
  }) async {
    final authToken = await authService.getAuthToken();

    final response = await client.delete(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      HttpHeaders.contentTypeHeader: "application/json"
    });
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PostResponse(statusCode: response.statusCode, data: {});
    } else {
      throw Exception("Unsupported status code ${response.statusCode}");
    }
  }
}
