import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc/blog_bloc.dart';
import '../repositories/blog_repository.dart';
import '../widgets/blog_item.dart';
import 'favorites_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogListScreen extends StatelessWidget {
  final BlogRepository repository;

  BlogListScreen({required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'lib/assets/images/black.png',
            width: 10,
            height: 10,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          "Blog Explorer",
          style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.black87),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => BlogBloc(repository)..add(FetchBlogs()),
        child: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BlogLoaded) {
              return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogItem(
                    blog: blog,
                    onFavoriteToggle: () {
                      context.read<BlogBloc>().add(ToggleFavorite(blog));
                    },
                  );
                },
              );
            } else if (state is BlogError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
