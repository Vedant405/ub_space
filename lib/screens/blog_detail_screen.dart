import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/blog.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  BlogDetailScreen({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          blog.title,
          style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(blog.imageUrl),
            const SizedBox(height: 16.0),
            Text(blog.title,
                style: TextStyle(fontSize: 24, color: Colors.black87)),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
