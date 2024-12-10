import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class   User with _$User{
// @JsonSerializable(fieldRename: FieldRename.snake) //todo uncomment if you need serializable in snake_case
  factory User({
    required int id,
   required String firstName,
   required String email,
}) = _User;
 factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}