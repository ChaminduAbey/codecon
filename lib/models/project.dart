import 'cdn_image.dart';

class Project {
  late int id;
  late String title;
  late String description;
  late String estTime;
  late int estCost;
  late String status;
  late CdnImage photo;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.estTime,
    required this.estCost,
    required this.status,
    required this.photo,
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
  }
}
