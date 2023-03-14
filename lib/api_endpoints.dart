class ApiEndpoints {
  static String baseUrl = "https://codecon.ego.surf";
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

  static String getProjectById({
    required int projectId,
  }) {
    return "$baseUrl/projects/$projectId";
  }

  static String addReview() {
    return "$baseUrl/reviews";
  }

  static String getIssuer({
    required int issuerId,
  }) {
    return "$baseUrl/issuers/$issuerId";
  }

  static String getContractor({
    required int contractorId,
  }) {
    return "$baseUrl/contractors/$contractorId";
  }

  static String getTimelineForProject({
    required int projectId,
  }) {
    return "$baseUrl/projects/$projectId/timeline";
  }
}
