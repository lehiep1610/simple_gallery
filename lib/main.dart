import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:simple_gallery/modules/gallery/controller/gallery_controller.dart';
import 'package:simple_gallery/modules/gallery/screen/gallery_screen.dart';
import 'package:simple_gallery/modules/log_in/controller/log_in_controller.dart';
import 'package:simple_gallery/modules/photo_viewer/controller/photo_viewer_controller.dart';
import 'package:simple_gallery/modules/photo_viewer/screen/photo_viewer_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/photo_list_response_model.dart';
import 'modules/log_in/screen/log_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(PhotoAdapter());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GalleryController()),
    ChangeNotifierProvider(create: (_) => PhotoViewerController()),
    ChangeNotifierProvider(create: (_) => LoginController())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      debugShowCheckedModeBanner: false,
      home: const LogInScreen(),
      routes: {
        GalleryScreen.routeName: (ctx) => const GalleryScreen(),
        PhotoViewerScreen.routeName: (ctx) => const PhotoViewerScreen(),
      },
    );
  }
}
