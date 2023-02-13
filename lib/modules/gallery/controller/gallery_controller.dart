// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:simple_gallery/constant/app_constant.dart';
import 'package:hive/hive.dart';

import '../../../models/photo_list_response_model.dart';
import '../../../network/base_api.dart';
import '../../../repositories/photo_repository.dart';

class GalleryController with ChangeNotifier {
  final PhotosRepository _repo = PhotosRepository();
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final List<Photo> _photoList = [];
  List<Photo> get photoList =>
      currentCategory == Category.All ? _photoList : _photoFavoriteList;
  final List<Photo> _photoFavoriteList = [];
  int photoIndex = 0;
  bool removedPhoto = false;
  int _currentTabIndex = 0;
  int get tabIndex => _currentTabIndex;
  Category currentCategory = Category.All;
  int pageNumber = 0;
  bool hasNextPage = true;
  String userId = '';

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
      EasyLoading.show();
      var photoListBox =
          await Hive.openBox<Photo>('${AppConstant.photoListBox}$userId');
      var photoGalleryBox =
          await Hive.openBox('${AppConstant.photoGalleryBox}$userId');

      // check if have response cache
      if (checkDB && photoListBox.values.isNotEmpty) {
        _photoList.addAll(photoListBox.values);

        hasNextPage = photoGalleryBox.get(AppConstant.hasNextPageKey);
        pageNumber = photoGalleryBox.get(AppConstant.nextPageNumberKey);
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
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> getFavoritePhoto() async {
    try {
      EasyLoading.show();
      var photoFavoriteBox =
          await Hive.openBox<Photo>('${AppConstant.photoFavoriteBox}$userId');
      if (photoFavoriteBox.values.isNotEmpty) {
        _photoFavoriteList.addAll(photoFavoriteBox.values);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  // add/remove photo in list photo and DB
  Future<void> onTapFavoriteButton({required int index}) async {
    photoList[index].isFavorite = !photoList[index].isFavorite!;
    if (photoList[index].isFavorite == true) {
      _photoFavoriteList.add(_photoList[index]);
      await Hive.box<Photo>('${AppConstant.photoFavoriteBox}$userId')
          .add(_photoList[index]);
      await Hive.box<Photo>('${AppConstant.photoListBox}$userId')
          .putAt(index, _photoList[index]);
      removedPhoto = false;
    } else {
      if (currentCategory == Category.All) {
        await Hive.box<Photo>('${AppConstant.photoListBox}$userId')
            .putAt(index, _photoList[index]);
        await Hive.box<Photo>('${AppConstant.photoFavoriteBox}$userId')
            .deleteAt(getIndex(index));
        _photoFavoriteList
            .removeWhere((photo) => _photoList[index].id == photo.id);
      } else {
        await Hive.box<Photo>('${AppConstant.photoListBox}$userId')
            .putAt(getIndex(index), _photoFavoriteList[index]);
        await Hive.box<Photo>('${AppConstant.photoFavoriteBox}$userId')
            .deleteAt(index);
        _photoFavoriteList.removeAt(index);
      }
      removedPhoto = true;
    }
    notifyListeners();
  }

  // convert index between two list
  int getIndex(int index) {
    Photo? photo = currentCategory == Category.All
        ? Hive.box<Photo>('${AppConstant.photoListBox}$userId').getAt(index)
        : Hive.box<Photo>('${AppConstant.photoFavoriteBox}$userId')
            .getAt(index);
    List<Photo> listPhoto =
        currentCategory == Category.All ? _photoFavoriteList : _photoList;

    for (int i = 0; i < listPhoto.length; ++i) {
      if (listPhoto[i].id == photo!.id) {
        return i;
      }
    }
    return -1;
  }

  void initGallery(String id) {
    userId = id;
    getListPhoto(checkDB: true);
    getFavoritePhoto();
  }

  // call api to load more photo
  void requestNextPage() {
    pageNumber++;
    getListPhoto();
  }

  // change list photo when change tab view
  void onChangeView({required int index}) {
    if (index == 0) {
      currentCategory = Category.All;
    } else if (index == 1) {
      currentCategory = Category.Favorite;
    }

    _currentTabIndex = index;

    notifyListeners();
  }

  void reset() {
    currentCategory = Category.All;
    _currentTabIndex = 0;
    _photoList.clear();
    _photoFavoriteList.clear();
  }

  @override
  void dispose() {
    Hive.close();
    _scrollController.dispose();
    super.dispose();
  }
}

enum Category { All, Favorite }
