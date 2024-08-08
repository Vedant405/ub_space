import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/blog.dart';
import '../../repositories/blog_repository.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository repository;

  BlogBloc(this.repository) : super(BlogInitial()) {
    on<FetchBlogs>((event, emit) async {
      emit(BlogLoading());
      try {
        final blogs = await repository.fetchBlogs();
        emit(BlogLoaded(blogs));
      } catch (_) {
        emit(BlogError("Failed to fetch blogs"));
      }
    });

    on<ToggleFavorite>((event, emit) async {
      final currentState = state;
      if (currentState is BlogLoaded) {
        final blogToUpdate = event.blog;
        final updatedBlog = Blog(
          id: blogToUpdate.id,
          title: blogToUpdate.title,
          imageUrl: blogToUpdate.imageUrl,
          isFavorite: !blogToUpdate.isFavorite,
        );

        try {
          await repository.updateBlog(updatedBlog);
          final updatedBlogs = currentState.blogs.map((blog) {
            return blog.id == blogToUpdate.id ? updatedBlog : blog;
          }).toList();
          emit(BlogLoaded(updatedBlogs));
        } catch (e) {
          print('Failed to update blog on server: $e'); //ERROR DETECTION
          emit(BlogError('Failed to update favorite status'));
        }
      }
    });

    on<FetchFavorites>((event, emit) async {
      final currentState = state;
      if (currentState is BlogLoaded) {
        final favorites =
            currentState.blogs.where((blog) => blog.isFavorite).toList();
        emit(FavoritesLoaded(favorites));
      }
    });
  }
}
