import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gallery/modules/gallery/controller/gallery_controller.dart';
import 'package:simple_gallery/modules/photo_viewer/controller/photo_viewer_controller.dart';

class PhotoViewerScreen extends StatefulWidget {
  static const routeName = '/photoViewerScreen';
  const PhotoViewerScreen({super.key});

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PhotoViewerController photoViewerController;
  late GalleryController galleryController;
  @override
  void initState() {
    photoViewerController =
        Provider.of<PhotoViewerController>(context, listen: false);
    galleryController = Provider.of<GalleryController>(context, listen: false);
    photoViewerController.photoIndex = galleryController.photoIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Listener(
        onPointerDown: (event) => photoViewerController.swipeDirection = '',
        onPointerMove: ((moveEvent) {
          photoViewerController.detectSwipeDirection(moveEvent: moveEvent);
        }),
        onPointerUp: (event) {
          photoViewerController.handleSwipeDirection(
            listPhotoLenght: galleryController.photoList.length,
          );
        },
        child: WillPopScope(
          onWillPop: () async {
            photoViewerController.reset();
            return true;
          },
          child: photoViewerController.photoIndex >= 0
              ? Scaffold(
                  floatingActionButton: !context
                          .watch<PhotoViewerController>()
                          .isZooming
                      ? GestureDetector(
                          onTap: () async {
                            await galleryController.onTapFavoriteButton(
                                index: photoViewerController.photoIndex);
                            if (galleryController.removedPhoto &&
                                galleryController.currentCategory ==
                                    Category.Favorite) {
                              photoViewerController.photoIndex--;
                              if (photoViewerController.photoIndex < 0) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[900],
                            ),
                            child: !context
                                    .watch<GalleryController>()
                                    .photoList[photoViewerController.photoIndex]
                                    .isFavorite!
                                ? const Icon(Icons.favorite_border_sharp)
                                : Icon(
                                    Icons.favorite,
                                    color: Colors.red[300],
                                  ),
                          ),
                        )
                      : null,
                  backgroundColor: Colors.black,
                  body: InteractiveViewer(
                    onInteractionStart: (details) {
                      if (details.pointerCount < 2) return;
                    },
                    transformationController:
                        photoViewerController.transformationController,
                    clipBehavior: Clip.none,
                    constrained: true,
                    maxScale: 4.0,
                    child: Center(
                      child: GestureDetector(
                        onDoubleTap: () {
                          photoViewerController.reset();
                        },
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          imageUrl: galleryController
                              .photoList[context
                                  .watch<PhotoViewerController>()
                                  .photoIndex]
                              .downloadUrl!,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
