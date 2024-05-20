class Album {
  final int albumId;
  final int id;
  String title;
  String url;
  String thumbnailUrl;

  Album({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
  return Album(
    albumId: json['albumId'] as int,
    id: json['id'] as int,
    title: json['title'] as String,
    url: json['url'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String, 
    );
}
}