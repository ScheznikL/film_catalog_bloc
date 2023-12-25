part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

final class RegisterSubmitted extends LoginEvent {
  const RegisterSubmitted();
}

final class AuthModeChange extends LoginEvent {
  final bool register;
  final AuthStat authStat;
  @override
  List<Object> get props => [register, authStat];

  const AuthModeChange({required this.register, required this.authStat});
}

