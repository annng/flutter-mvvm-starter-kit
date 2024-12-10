import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/data/services/api_client_dio.dart';
import 'package:flutter_mvvm/utils/ui_state.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../domain/models/user/user.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required UserRepository userRepository,
  }) :
        // Repositories are manually assigned because they're private members.
        _userRepository = userRepository{
    load();
  }

  final UserRepository _userRepository;
  final _log = Logger('HomeViewModel');

  final UiState<List<User>> usersNotifier = UiState<List<User>>();
  final UiState<User> userDetailsNotifier = UiState<User>();

  Future<void> load() async {
    usersNotifier.setLoading(true);
    try {
      final userResult = await _userRepository.getUsers();
      usersNotifier.setLoading(false);
      if (userResult.data != null) {
        usersNotifier.setData(userResult.data!);
        notifyListeners();
      }
    } on ApiClientException catch (e) {
      log(e.responseMessage);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getUser(int id) async {
    try {
      final userResult = await _userRepository.getUser(id);
      if(userResult.data != null) {
        userDetailsNotifier.setData(userResult.data!);
      }else{
        userDetailsNotifier.setError(userResult.message);
      }
      notifyListeners();
    } on ApiClientException catch (e) {
      log(e.responseMessage);
    } finally {
      notifyListeners();
    }
  }
}
