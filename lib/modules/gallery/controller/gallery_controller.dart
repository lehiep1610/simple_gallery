import 'package:flutter/material.dart';

import '../../../models/photo_list_response_model.dart';
import '../../../network/base_api.dart';
import '../../../repositories/photo_repository.dart';

class GalleryController with ChangeNotifier {
  final PhotosRepository _repo = PhotosRepository();
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final List<Photo> _photoList = [];
  List<Photo> get photoList => _photoList;

  Future<void> getListPhoto() async {
    final Response<List<Photo>> response = await _repo.getPhotosList(0);
    _photoList.addAll(response.body);
    notifyListeners();
  }
}
