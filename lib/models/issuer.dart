import 'package:client_app/models/project.dart';
import 'package:client_app/models/review.dart';

import 'cdn_image.dart';

class Issuer {
  late int id;
  late String title;
  late String description;
  late CdnImage photo;
  late List<Project>? projects;
  late List<Review>? reviews;
  Issuer({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    this.projects,
    this.reviews,
  });

  Issuer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];

    if (json['images'] != null) {
      photo = CdnImage.fromJson(json['images']);
    }

    if (json['projects'] != null) {
      projects = [];
      json['projects'].forEach((v) {
        projects!.add(Project.fromJson(v));
      });
    }

    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews!.add(Review.fromJson(v));
      });
    }
  }
}
