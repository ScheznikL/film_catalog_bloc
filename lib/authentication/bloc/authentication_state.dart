part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationProgress.unknown,
    this.user = User.empty,
    this.userData = UserData.empty,
    this.message = "",
  });

  const AuthenticationState.userAlreadyExist(User user) : this._(
      status: AuthenticationProgress.alreadyExist,
      user: user,);

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user, UserData userData)
      : this._(
            status: AuthenticationProgress.authenticated,
            user: user,
            userData: userData);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationProgress.unauthenticated);

  const AuthenticationState.error(String message)
      : this._(status: AuthenticationProgress.error, message: message);

  const AuthenticationState.notFound()
      : this._(status: AuthenticationProgress.noUserFound);

  const AuthenticationState.registered(User user, UserData userData)
      : this._(
            status: AuthenticationProgress.registered,
            user: user,
            userData: userData);

  final AuthenticationProgress status;
  final User user;
  final UserData userData;
  final String? message;

  @override
  List<Object?> get props => [status, user, userData, message];
}
