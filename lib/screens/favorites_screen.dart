import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc/blog_bloc.dart';
import '../widgets/blog_item.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlogLoaded) {
            final favorites =
                state.blogs.where((blog) => blog.isFavorite).toList();
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final blog = favorites[index];
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
    );
  }
}
