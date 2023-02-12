import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../constant/app_constant.dart';
import '../../../models/photo_list_response_model.dart';

class PhotoViewerController with ChangeNotifier {
  final transformationController = TransformationController();

  bool isFavorite = false;
  int photoIndex = 0;
  bool isZooming = false;
  String swipeDirection = '';

  void reset() {
    transformationController.value = Matrix4.identity();
    userHasZoomIn();
  }

  void onTapFavorite(Photo photo) {
    isFavorite = !isFavorite;

    //store to DB
    var photoFavoriteBox = Hive.box<Photo>(AppConstant.photoFavoriteBox);
    photoFavoriteBox.add(photo);
    notifyListeners();
  }

  String detectSwipeDirection({required PointerMoveEvent moveEvent}) {
    if (userHasZoomIn()) {
      return swipeDirection = '';
    }

    if (moveEvent.delta.dx < 0) {
      return swipeDirection = 'left';
    } else if (moveEvent.delta.dx > 0) {
      return swipeDirection = 'right';
    }
    return swipeDirection = '';
  }

  void handleSwipeDirection({required int listPhotoLenght}) {
    if (swipeDirection == '') {
      return;
    }
    if (swipeDirection == 'left' && photoIndex < listPhotoLenght - 1) {
      photoIndex++;
      notifyListeners();
    } else if (swipeDirection == 'right' && photoIndex > 0) {
      photoIndex--;
      notifyListeners();
    }
  }

  bool userHasZoomIn() {
    isZooming =
        (Matrix4.identity() - transformationController.value).infinityNorm() >
            0.000001;
    notifyListeners();
    return isZooming;
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }
}
