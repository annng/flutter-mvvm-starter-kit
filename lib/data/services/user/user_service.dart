import 'package:flutter_mvvm/domain/models/user/user.dart';

import '../../../domain/models/base_response.dart';
import '../api_client_dio.dart';

class UserService {
  final ApiClient _httpClient;

  UserService(this._httpClient);

  Future<BaseResponse<User>> user(int id) async {
    try {
      final response = await _httpClient.get('/v1/profile/$id');
      final respData =
          BaseResponse.fromJson(response, (data) => User.fromJson(data));
      return respData;
    } on Exception catch (e) {
      return BaseResponse.error(e.toString());
    }
  }
}
