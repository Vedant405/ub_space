import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/blog.dart';

class BlogRepository {
  final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  final String adminSecret =
      '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';
  final Box<Blog> blogBox = Hive.box<Blog>('blogs');

  Future<List<Blog>> fetchBlogs() async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('blogs')) {
          final List<dynamic> blogList = data['blogs'];
          final List<Blog> blogs = blogList
              .map((json) => Blog.fromJson(json as Map<String, dynamic>))
              .toList();

          await blogBox.clear();
          for (var blog in blogs) {
            await blogBox.put(blog.id, blog);
          }
          return blogs;
        } else {
          throw Exception('Unexpected JSON format: Missing "blogs" key');
        }
      } else {
        throw Exception(
            'Failed to fetch blogs. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchBlogs: $e');
      return blogBox.values.toList();
    }
  }

  Future<void> updateBlog(Blog blog) async {
    final updateUrl = '$url/${blog.id}';
    try {
      final response = await http.patch(
        Uri.parse(updateUrl),
        headers: {
          'x-hasura-admin-secret': adminSecret,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': blog.title,
          'image_url': blog.imageUrl,
          'is_favorite': blog.isFavorite,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updateBlog: $e');
    } finally {
      await blogBox.put(blog.id, blog);
    }
  }
}
