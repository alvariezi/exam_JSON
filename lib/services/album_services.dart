import 'dart:convert';
import 'package:exam/models/album.dart';
import 'package:http/http.dart' as http;

class AlbumService {
  static String baseUrl = 'https://jsonplaceholder.typicode.com/albums';

  static Future<List<Album>> fetchAlbum() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/1/photos'));
      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        List<Album> album = result.map((albumJson) => Album.fromJson(albumJson)).toList();
        return album;
      } else {
        throw Exception('Failed to load albums');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> addAlbum(Album album) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId': album.albumId,
          'title': album.title,
          'url': album.url,
          'thumbnailUrl': album.thumbnailUrl,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add album');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> editAlbum(Album album) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${album.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId': album.albumId,
          'title': album.title,
          'url': album.url,
          'thumbnailUrl': album.thumbnailUrl,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update album');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> deleteAlbum(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete album');
      }
    } catch (e) {
      throw Exception(e.toString());
   }
 }
}