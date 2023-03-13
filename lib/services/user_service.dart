import 'package:client_app/models/user.dart';
import 'package:client_app/services/http_service.dart';
import 'package:client_app/services/storage_service.dart';

import '../api_endpoints.dart';
import 'auth_service.dart';

class UserService {
  UserService({
    required this.httpService,
    required this.authService,
  });

  final HttpService httpService;
  final ApiEndpoints apiEndpoints = ApiEndpoints();
  final AuthService authService;

  User? _user;

  User get user => _user!;

  Future<void> signInUser({required int userId}) async {
    final authToken = await httpService.get<String>(
      url: apiEndpoints.loginUser(userId: userId),
      fromJson: (json) => json['token'],
    );
    await authService.setAuthToken(token: authToken);
  }

  Future<User> getUserMe() async {
    _user = await httpService.secureGet<User>(
      url: ApiEndpoints.getUserMe(),
      fromJson: (json) => User.fromJson(json),
    );
    return _user!;
  }
}
