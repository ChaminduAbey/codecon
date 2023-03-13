class CdnImage {
  late int id;
  late String blurhash;
  late String url;

  CdnImage({
    required this.id,
    required this.blurhash,
    required this.url,
  });

  CdnImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blurhash = json['blurhash'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['blurhash'] = this.blurhash;
    data['url'] = this.url;
    return data;
  }
}
