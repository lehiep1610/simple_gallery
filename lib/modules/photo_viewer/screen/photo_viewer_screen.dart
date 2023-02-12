import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gallery/modules/gallery/controller/gallery_controller.dart';
import 'package:simple_gallery/modules/photo_viewer/controller/photo_viewer_controller.dart';

class PhotoViewerScreen extends StatefulWidget {
  final int index;
  const PhotoViewerScreen({super.key, required this.index});

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
    photoViewerController.photoIndex = widget.index;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              listPhotoLenght: galleryController.photoList.length);
        },
        child: WillPopScope(
          onWillPop: () async {
            photoViewerController.reset();
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: GestureDetector(
                onDoubleTap: () {
                  photoViewerController.reset();
                },
                child: InteractiveViewer(
                  onInteractionStart: (details) {
                    if (details.pointerCount < 2) return;
                    photoViewerController.isZooming = true;
                  },
                  onInteractionEnd: (details) {
                    photoViewerController.isZooming = false;
                  },
                  transformationController:
                      photoViewerController.transformationController,
                  clipBehavior: Clip.none,
                  constrained: true,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: galleryController
                        .photoList[
                            context.watch<PhotoViewerController>().photoIndex]
                        .downloadUrl!,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
