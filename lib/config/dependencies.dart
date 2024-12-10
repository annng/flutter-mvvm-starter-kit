import 'package:flutter_mvvm/data/repositories/user/user_repository.dart';
import 'package:flutter_mvvm/data/repositories/user/user_repository_remote.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/services/api_client_dio.dart';

/// Configure dependencies for remote data.
/// This dependency list uses repositories that connect to a remote server.

List<SingleChildWidget> get providersRemote {
  return [
    Provider(
      create: (context) => ApiClient(),
    ),
    Provider(
      create: (context) => UserRepositoryRemote(
        apiClient: context.read(),
      ) as UserRepository,
    ),
  ];
}