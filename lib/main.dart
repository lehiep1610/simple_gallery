import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:simple_gallery/modules/gallery/controller/gallery_controller.dart';

import 'models/photo_list_response_model.dart';
import 'modules/log_in/screen/log_in_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PhotoAdapter());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => GalleryController(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogInScreen(),
    );
  }
}
