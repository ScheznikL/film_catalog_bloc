part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status);
 // const AuthenticationStatusChanged.withUser(this.status, this.user);

  final AuthenticationStatus status;
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}

final class AuthenticationLoginDenied extends AuthenticationEvent {}