import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gallery/modules/log_in/controller/log_in_controller.dart';

import '../../../utils/Image_mixin.dart';
import '../controller/gallery_controller.dart';
import '../page/account_page.dart';
import '../page/all_photo_page.dart';
import '../page/favorite_page.dart';

class GalleryScreen extends StatefulWidget with ImageMixin {
  const GalleryScreen({super.key});
  static const routeName = '/galleryScreen';

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late GalleryController galleryController;
  final screen = [
    const AllPhotoPage(),
    const FavoritePage(),
    const AccountPage()
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      galleryController =
          Provider.of<GalleryController>(context, listen: false);
      galleryController
          .initGallery(context.read<LoginController>().user?.id ?? '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Photo gallery'),
        ),
        body: screen[context.watch<GalleryController>().tabIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<GalleryController>().tabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (currentIndex) {
            galleryController.onChangeView(index: currentIndex);
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Gallery',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Favorite',
              icon: Icon(Icons.favorite_sharp),
            ),
            BottomNavigationBarItem(
              label: 'Account',
              icon: Icon(Icons.manage_accounts),
            ),
          ],
        ),
      ),
    );
  }
}
