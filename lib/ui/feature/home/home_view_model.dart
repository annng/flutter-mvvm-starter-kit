import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/config/core/base_cubit.dart';
import 'package:flutter_mvvm/ui/feature/home/home_state.dart' show HomeState;

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

  final PageController pageController = PageController();


  HomeState uiState =
      HomeState(user: null, users: null, currentNavigationIndex: 0);

  Future<void> load() async {
    try {
      // final user = await _userRepository.getUsers();
      uiState = uiState.copyWith(currentNavigationIndex: 0);
      emitSuccess(uiState);
    } catch (error) {
      emitError(error.toString());
    }
  }

  void setCurrentNavigationItem(int currentIndex) {
    try {
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      uiState = uiState.copyWith(currentNavigationIndex: currentIndex);
      emitSuccess(uiState);
    }catch (error){
      emitError(error.toString());
    }
  }
}
