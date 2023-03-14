import 'package:client_app/models/issuer.dart';
import 'package:client_app/models/post_response.dart';
import 'package:client_app/models/project.dart';
import 'package:client_app/models/review.dart';
import 'package:client_app/models/timeline.dart';
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

  Future<Issuer> getIssuer(
      {required int issuerId, required bool isIssuer}) async {
    return await httpService.get<Issuer>(
      url: isIssuer
          ? ApiEndpoints.getIssuer(issuerId: issuerId)
          : ApiEndpoints.getContractor(contractorId: issuerId),
      fromJson: (json) => Issuer.fromJson(json),
    );
  }

  Future<Project> getProjectById({
    required int projectId,
  }) async {
    return await httpService.get<Project>(
      url: ApiEndpoints.getProjectById(projectId: projectId),
      fromJson: (json) => Project.fromJson(json),
    );
  }

  Future<List<Timeline>> getTimelineForProject({
    required int projectId,
  }) async {
    return await httpService.getList<Timeline>(
      url: ApiEndpoints.getTimelineForProject(projectId: projectId),
      fromJson: (json) => Timeline.fromJson(json),
    );
  }
}
