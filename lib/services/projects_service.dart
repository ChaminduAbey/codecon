import 'package:client_app/models/post_response.dart';
import 'package:client_app/models/project.dart';
import 'package:client_app/models/review.dart';
import 'package:client_app/services/http_service.dart';
import 'package:flutter/cupertino.dart';

import '../api_endpoints.dart';

class ProjectService extends ChangeNotifier {
  ProjectService({
    required this.httpService,
  });

  final HttpService httpService;

  List<Project> _projects = [];

  List<Project> get projects => _projects;

  void setProjects(List<Project> projects) {
    _projects = projects;
    notifyListeners();
  }

  Future<List<Project>> getProjectsNearBy() async {
    return await httpService.getList<Project>(
      url: ApiEndpoints.getProjects(),
      fromJson: (json) => Project.fromJson(json),
    );
  }

  Future<PostResponse> addReview({required Review review}) async {
    return await httpService.securePost(
        url: ApiEndpoints.addReview(), body: review.toJson());
  }
}
