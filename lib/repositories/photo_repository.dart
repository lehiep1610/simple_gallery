import '../constant/app_constant.dart';
import '../models/photo_list_response_model.dart';
import '../network/base_api.dart';
import '../network/end_point.dart';

class PhotosRepository {
  final BaseApi _baseApi = BaseApi();

  Future<Response<List<Photo>>> getPhotosList(int pageNumber) async {
    final Response response = await _baseApi.get(
        '${Endpoints.baseURL + Endpoints.photoList}/?page=$pageNumber&limit=${AppConstant.photoPerPage}');
    return Response(photoListFromJson(response.body), response.statusCode,
        response.headers);
  }
}
