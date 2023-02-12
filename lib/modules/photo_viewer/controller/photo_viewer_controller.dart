import 'package:flutter/material.dart';

class PhotoViewerController with ChangeNotifier {
  final transformationController = TransformationController();

  bool isFavorite = false;
  int photoIndex = 0;
  bool isZooming = false;
  String swipeDirection = '';

  void reset() {
    transformationController.value = Matrix4.identity();
  }

  void onTapFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void onLeftSwipe() {
    photoIndex++;
    notifyListeners();
  }

  void onRightSwipe() {
    photoIndex--;
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
    return (Matrix4.identity() - transformationController.value)
            .infinityNorm() >
        0.000001;
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }
}
