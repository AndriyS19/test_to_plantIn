import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:test_to_plantin/models/photo_model.dart';

class GalleryService {
  static const String _baseUrl = 'https://picsum.photos/v2/list';
  static const int _pageSize = 20;

  Future<List<Photo>> fetchPhotos(int page) async {
    try {
      log('📸 Fetching photos from page $page...');

      final response = await http.get(Uri.parse('$_baseUrl?page=$page&limit=$_pageSize'));

      log('📸 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log('📸 Loaded ${data.length} photos');
        return data.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Error loading photos: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error. Please check your connection.');
    }
  }
}
