import 'cdn_image.dart';

class User {
  late int id;
  late String firstName;
  late String lastName;
  late String email;
  late int photoId;
  late CdnImage? photo;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photoId,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    photoId = json['photo_id'];

    if (json['images'] != null) {
      photo = CdnImage.fromJson(json['images']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['photo_id'] = this.photoId;
    return data;
  }
}
