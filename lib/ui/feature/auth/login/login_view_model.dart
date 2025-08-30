import 'package:flutter_mvvm/ui/feature/auth/login/login_state.dart';

import '../../../../config/core/base_cubit.dart';

class LoginViewModel extends BaseCubit<LoginState> {
  LoginViewModel() {
    setObsecure(false);
  }

  LoginState uiState = LoginState(obsecurePassword: false);

  Future<void> setObsecure(bool isObsecure) async {
    try {
      uiState = uiState.copyWith(obsecurePassword: isObsecure);
      emitSuccess(uiState);
    } catch (error) {
      emitError(error.toString());
    }
  }
}
