import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_gallery/constant/app_constant.dart';

import '../../../models/photo_list_response_model.dart';
import '../../../network/base_api.dart';
import '../../../repositories/photo_repository.dart';
import 'package:hive/hive.dart';

class GalleryController with ChangeNotifier {
  final PhotosRepository _repo = PhotosRepository();
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final List<Photo> _photoList = [];
  List<Photo> get photoList => _photoList;
  bool isLoading = false;

  int pageNumber = 0;
  bool hasNextPage = true;

  GalleryController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange &&
          hasNextPage) {
        requestNextPage();
      }
    });
  }

  Future<void> getListPhoto({bool checkDB = false}) async {
    try {
      isLoading = true;
      var photoListBox = await Hive.openBox<Photo>(AppConstant.photoListBox);
      var photoGalleryBox = await Hive.openBox(AppConstant.photoGalleryBox);

      if (checkDB && photoListBox.values.isNotEmpty) {
        _photoList.addAll(photoListBox.values);

        hasNextPage = photoGalleryBox.get(AppConstant.hasNextPageKey);
        pageNumber = photoGalleryBox.get(AppConstant.nextPageNumberKey);
        isLoading = false;
        notifyListeners();
        return;
      }

      if (hasNextPage) {
        final Response<List<Photo>> response =
            await _repo.getPhotosList(pageNumber);

        if (response.headers['link'].toString().contains('rel="next"')) {
          hasNextPage = true;
          pageNumber++;
        } else {
          hasNextPage = false;
        }

        _photoList.addAll(response.body);

        // Store information to DB
        photoListBox.addAll(response.body);

        photoGalleryBox.put(AppConstant.nextPageNumberKey, pageNumber);
        photoGalleryBox.put(AppConstant.hasNextPageKey, hasNextPage);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void initGallery() {
    getListPhoto(checkDB: true);
  }

  void requestNextPage() {
    pageNumber++;
    getListPhoto();
  }
}
