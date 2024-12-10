import 'package:flutter_mvvm/data/repositories/user/user_repository.dart';
import 'package:flutter_mvvm/domain/models/base_response.dart';

import '../../../domain/models/user/user.dart';
import '../../services/api_client_dio.dart';

class UserRepositoryRemote implements UserRepository {
  UserRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  User? _cachedData;
  final BaseResponse<List<User>> userResponse = BaseResponse.empty();


  @override
  Future<BaseResponse<User>> getUser(int id) async {
    try {
      final response = await _apiClient.get('/users/$id');
      // final respData = BaseResponse.fromJson(response, (data) => User.fromJson(response));
      final respData = BaseResponse(User.fromJson(response), true, "Success");
      return respData;
    } catch (e){
      return BaseResponse.error(e.toString());
    }
  }

  @override
  Future<BaseResponse<List<User>>> getUsers() async {
    try {
      final response = await _apiClient.get('/users');
      final data = response["users"] as List<dynamic>;
      final users = data.map((user) => User.fromJson(user)).toList();

      final respData =
      BaseResponse<List<User>>.fromJson(response, (data) => users);

      return respData;
    } catch (e){
      return BaseResponse.error(e.toString());
    }
  }
}
