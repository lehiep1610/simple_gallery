part of 'gallery_screen.dart';

extension _GalleryScreenChildren on GalleryScreen {
  Widget photosGridView({required BuildContext context}) {
    return GridView.builder(
      controller: context.read<GalleryController>().scrollController,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => PhotoViewerScreen(index: index)),
              ),
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
