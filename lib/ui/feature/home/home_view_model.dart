import 'package:flutter_mvvm/config/core/base_cubit.dart';
import 'package:flutter_mvvm/ui/feature/home/home_state.dart' show HomeState;
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';

class HomeViewModel extends BaseCubit<HomeState> {
  HomeViewModel({
    required UserRepository userRepository,
  }) :
        // Repositories are manually assigned because they're private members.
        _userRepository = userRepository {
    load();
  }

  final UserRepository _userRepository;

   HomeState uiState = HomeState(user: null, users: null);

  Future<void> load() async {
    emitLoading();
    try {
      final user = await _userRepository.getUsers();
      uiState = uiState.copyWith(users: user.data);
      emitSuccess(uiState);
    } catch (error) {
      emitError(error.toString());
    }
  }

  Future<void> fetchUserDetails(int id) async {
    // emitLoading(); //general loading
    // emitSuccess(uiState.copyWith(loadingx : true)); //spesific loading by define flag in uistate
    try {
      final user = await _userRepository.getUser(id);
      uiState = uiState.copyWith(user: user.data);
      emitSuccess(uiState);
    } catch (error) {
      emitError(error.toString());
    }
  }
}
