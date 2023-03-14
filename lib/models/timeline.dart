import 'package:client_app/models/project.dart';
import 'package:client_app/models/review.dart';

import 'cdn_image.dart';

class Timeline {
  late int id;
  late String text;
  late DateTime date;

  Timeline({
    required this.id,
    required this.text,
    required this.date,
  });

  Timeline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    date = DateTime.parse(json['date']);
  }
}
