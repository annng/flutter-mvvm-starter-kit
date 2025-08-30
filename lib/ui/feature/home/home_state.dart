import '../../../domain/models/user/user.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';
part 'home_state.g.dart';

@freezed
abstract class HomeState with _$HomeState {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory HomeState({
    required User? user,
    required List<User>? users,
  }) = _HomeState;

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);
}
