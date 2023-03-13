import 'package:client_app/models/user.dart';

import 'cdn_image.dart';

class Review {
  late int id;
  late String review;
  late double rating;
  late int projectId;

  User? user;

  Review(
      {required this.id,
      required this.review,
      required this.rating,
      required this.projectId,
      this.user});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'];
    rating = json['rating'];
    projectId = json['project_id'];

    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['project_id'] = this.projectId;
    return data;
  }
}
