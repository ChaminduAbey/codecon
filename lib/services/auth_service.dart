import 'package:client_app/api_endpoints.dart';

import '../exceptions/unauthenticated_exception.dart';
import '../models/post_response.dart';
import 'http_service.dart';
import 'storage_service.dart';

class AuthService {
  AuthService({
    required this.storageService,
  });

  final StorageService storageService;

  Future<String> getAuthToken() async {
    final token = await storageService.getString("AUTH_TOKEN");
    if (token == null) {
      throw UnauthenticatedException();
    }
    return token;
  }

  Future<String> setAuthToken({
    required String token,
  }) async {
    await storageService.setString("AUTH_TOKEN", token);
    return token;
  }

  Future<void> logout() async {
    await storageService.remove("AUTH_TOKEN");
  }
}
