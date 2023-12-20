import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed()
class User with _$User {
  const factory User({
    required String id,
    required String login,
    required String password,
}) = _User;

  static const empty = User(id: "0",login: "none",password: "0");

  factory User.fromJson(Map<String, dynamic> json)
  => _$UserFromJson(json);
}
