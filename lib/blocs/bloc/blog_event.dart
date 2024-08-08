part of 'blog_bloc.dart';

@immutable
abstract class BlogEvent {}

class FetchBlogs extends BlogEvent {}

class ToggleFavorite extends BlogEvent {
  final Blog blog;

  ToggleFavorite(this.blog);
}

class FetchFavorites extends BlogEvent {}
