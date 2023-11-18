import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/tags/model/tag_model.dart';

import '../../constants/logger.dart';
import '../../constants/request_interceptor.dart';
import '../../constants/shared_prefs.dart';
import '../../space/model/space_model.dart';
import '../model/tag_request.dart';

var sl = GetIt.instance;

abstract class TagApi {
  // Get Tags
  Future<List<TagModel>> getTags();
  // Create Tag
  Future<TagModel> updateTag(TagRequest tagRequest, String id);
}

class TagApiImpl implements TagApi {
  @override
  Future<List<TagModel>> getTags() async {
    // TODO: implement getTags
    var interceptor = sl.get<RequestInterceptor>();
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    final res = await dio.get("/space/${space.id}/tag");
    if (res.statusCode == 200) {
      var response = res.data;
      if (response is Map && response['statusCode'] != null) {
        // logger.d(response);
        throw Exception(response['message']);
      }
      logger.d(response);
      List responseData = response;
      List<TagModel> tags =
          responseData.map((data) => TagModel.fromJson(data)).toList();
      return tags;
    }
    throw Exception(res.data["message"]);
  }

  @override
  Future<TagModel> updateTag(TagRequest tagRequest, String id) async {
    // TODO: implement updateTag
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    var prefs = sl<SharedPreferenceModule>();
    Space? space = prefs.getSpaces().first;
    final res = await dio.patch("/space/${space.id}/tag/$id",
        data: tagRequest.toJson());
    if (res.statusCode == 200) {
      var response = res.data;
      if (response is Map && response['statusCode'] != null) {
        logger.d(response);
        throw Exception(response['message']);
      }
      // logger.d(response);
      return TagModel.fromJson(response);
    }
    throw Exception(res.data["message"]);
  }
}
