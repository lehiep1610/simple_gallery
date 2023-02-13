import '../constant/app_constant.dart';

mixin ImageMixin {
  resizeImage(String? photoUrl) {
    removeUntilLastOccuernce(String str, String pattern) {
      return str.substring(0, str.lastIndexOf(pattern));
    }

    photoUrl = photoUrl != null
        ? '${removeUntilLastOccuernce(removeUntilLastOccuernce(photoUrl, '/'), '/')}/${AppConstant.imageThumbnailSize}/${AppConstant.imageThumbnailSize}'
        : photoUrl;
    return photoUrl;
  }
}
