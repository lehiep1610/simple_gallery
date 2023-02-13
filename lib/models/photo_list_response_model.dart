import 'dart:convert';
import 'package:hive/hive.dart';

part 'photo_list_response_model.g.dart';

List<Photo> photoListFromJson(String str) =>
    List<Photo>.from(json.decode(str).map((x) => Photo.fromJson(x)));

@HiveType(typeId: 0)
class Photo {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? author;
  @HiveField(2)
  int? width;
  @HiveField(3)
  int? height;
  @HiveField(4)
  String? url;
  @HiveField(5)
  String? downloadUrl;
  @HiveField(6)
  bool? isFavorite;

  Photo({
    this.id,
    this.author,
    this.width,
    this.height,
    this.url,
    this.downloadUrl,
    this.isFavorite = false,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String?,
      author: json['author'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      url: json['url'] as String?,
      downloadUrl: json['download_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'width': width,
        'height': height,
        'url': url,
        'download_url': downloadUrl,
      };
}
