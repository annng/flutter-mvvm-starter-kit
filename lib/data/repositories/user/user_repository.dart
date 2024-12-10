import 'package:flutter_mvvm/domain/models/base_response.dart';

import '../../../domain/models/user/user.dart';

abstract class UserRepository {
  /// Get current user
  Future<BaseResponse<List<User>>> getUsers();
  Future<BaseResponse<User>> getUser(int id);
}