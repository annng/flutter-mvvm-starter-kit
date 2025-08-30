import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';
part 'login_state.g.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    required bool obsecurePassword,
  }) = _LoginState;

  factory LoginState.fromJson(Map<String, Object?> json) => _$LoginStateFromJson(json);
}