part of 'blog_bloc.dart';

@immutable
abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final List<Blog> blogs;

  BlogLoaded(this.blogs);
}

class BlogError extends BlogState {
  final String message;

  BlogError(this.message);
}

class FavoritesLoaded extends BlogState {
  final List<Blog> favorites;

  FavoritesLoaded(this.favorites);
}
