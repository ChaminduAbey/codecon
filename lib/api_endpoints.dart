class ApiEndpoints {
  static String baseUrl = "http://192.168.1.29:3000";
  String getUsers() {
    return "$baseUrl/users";
  }

  String loginUser({required int userId}) {
    return "$baseUrl/users/$userId/login";
  }

  static getUserMe() {
    return "$baseUrl/users/me";
  }

  static String getProjects() {
    return "$baseUrl/projects";
  }
}
