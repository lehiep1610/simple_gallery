import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/app_constant.dart';
import '../../../constant/image_constant.dart';
import '../../../models/photo_list_response_model.dart';
import '../../photo_viewer/screen/photo_viewer_screen.dart';
import '../controller/gallery_controller.dart';
import '../../../utils/Image_mixin.dart';

class FavoritePage extends StatelessWidget with ImageMixin {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<GalleryController>().photoList.isEmpty
        ? const Center(
            child: Text(
              'There are no favorite photo yet!',
              style: TextStyle(fontSize: 20),
            ),
          )
        : GridView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.read<GalleryController>().photoIndex = index;
                  Navigator.of(context).pushNamed(
                    PhotoViewerScreen.routeName,
                  );
                },
                child: _imageBox(
                    photo: context.watch<GalleryController>().photoList[index],
                    width: AppConstant.galleryThumbnailSize,
                    height: AppConstant.galleryThumbnailSize),
              );
            },
            itemCount: context.watch<GalleryController>().photoList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (MediaQuery.of(context).size.width /
                      AppConstant.galleryThumbnailSize)
                  .round(),
              crossAxisSpacing: AppConstant.galleryCrossAxisSpacing,
              mainAxisSpacing: AppConstant.galleryMainAxisSpacing,
            ),
            scrollDirection: Axis.vertical,
          );
  }

  Widget _imageBox(
      {required Photo photo, double? height, double? width, BoxFit? fit}) {
    return CachedNetworkImage(
      errorWidget: (context, url, error) =>
          Image.asset(ImageConstants.img_error_image),
      placeholder: (context, url) =>
          Image.asset(ImageConstants.img_placeholder),
      imageUrl: resizeImage(photo.downloadUrl),
      fit: fit,
      height: height,
      width: width,
    );
  }
}
