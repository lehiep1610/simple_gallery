import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_gallery/constant/image_constant.dart';
import 'package:simple_gallery/models/photo_list_response_model.dart';
import 'package:provider/provider.dart';

import '../../../constant/app_constant.dart';
import '../../../utils/Image_mixin.dart';
import '../../photo_viewer/screen/photo_viewer_screen.dart';
import '../controller/gallery_controller.dart';

part 'gallery_screen_children.dart';

class GalleryScreen extends StatefulWidget with ImageMixin {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GalleryController>(context, listen: false).initGallery();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: context.watch<GalleryController>().isLoading
            ? const CircularProgressIndicator()
            : widget.photosGridView(context: context),
      ),
    );
  }
}
