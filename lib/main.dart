import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/blog_repository.dart';
import 'blocs/bloc/blog_bloc.dart';
import 'screens/blog_list_screen.dart';
import 'utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/blog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BlogAdapter());
  await Hive.openBox<Blog>('blogs');

  runApp(BlogExplorerApp());
}

class BlogExplorerApp extends StatelessWidget {
  final BlogRepository repository = BlogRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Explorer',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        cardColor: primaryColor,
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.ubuntu(color: textColor),
          bodyMedium: GoogleFonts.ubuntu(color: textColor),
        ),
        appBarTheme: AppBarTheme(
          color: primaryColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          background: backgroundColor,
          surface: primaryColor,
        ),
      ),
      home: BlocProvider(
        create: (context) => BlogBloc(repository)..add(FetchBlogs()),
        child: BlogListScreen(repository: repository),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
