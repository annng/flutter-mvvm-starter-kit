import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm/data/repositories/user/user_repository.dart';
import 'package:flutter_mvvm/data/repositories/user/user_repository_remote.dart';
import 'package:flutter_mvvm/ui/feature/auth/login/login_view_model.dart';
import 'package:flutter_mvvm/ui/feature/home/home_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/services/api_client_dio.dart';
import '../routing/session_cubit.dart';

/// Configure dependencies for remote data.
/// This dependency list uses repositories that connect to a remote server.

List<SingleChildWidget> get providersRemote {
  return [
    Provider(
      create: (context) => ApiClient(),
    ),
    Provider(
      create: (context) => const FlutterSecureStorage(),
    ),
    Provider(
      create: (context) => UserRepositoryRemote(
        apiClient: context.read(),
      ) as UserRepository,
    ),
  ];
}

List<SingleChildWidget> get blocProvider {
  return [
    BlocProvider<SessionCubit>(
      create: (context) => SessionCubit(context.read<FlutterSecureStorage>()),
    ),
    BlocProvider<HomeViewModel>(
      create: (context) =>
          HomeViewModel(userRepository: context.read<UserRepository>()),
    ),
    BlocProvider<LoginViewModel>(
      create: (context) => LoginViewModel(),
    ),
  ];
}
