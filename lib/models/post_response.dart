class PostResponse {
  PostResponse({
    required this.statusCode, 
    required this.data,
  });

  int statusCode; 
  Map<String, dynamic> data;
}
