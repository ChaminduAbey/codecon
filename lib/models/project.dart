import 'package:client_app/models/review.dart';

import 'cdn_image.dart';
import 'issuer.dart';

class Project {
  late int id;
  late String title;
  late String description;
  late String estTime;
  late int estCost;
  late String status;
  late CdnImage photo;
  late Issuer issuer;
  late Issuer contractor;
  late List<Review> reviews;
  late List<Issuer> bidders;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.estTime,
    required this.estCost,
    required this.status,
    required this.photo,
    required this.issuer,
    required this.reviews,
    required this.bidders,
  });

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    estTime = json['est_time'];
    estCost = json['est_cost'];
    status = json['status'];

    if (json['images'] != null) {
      photo = CdnImage.fromJson(json['images']);
    }

    if (json['issuer'] != null) {
      issuer = Issuer.fromJson(json['issuer']);
    }

    if (json['contractor'] != null) {
      contractor = Issuer.fromJson(json['contractor']);
    }

    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews.add(Review.fromJson(v));
      });
    }

    if (json['bidders'] != null) {
      bidders = [];
      json['bidders'].forEach((v) {
        bidders.add(Issuer.fromJson(v));
      });
    }
  }
}
