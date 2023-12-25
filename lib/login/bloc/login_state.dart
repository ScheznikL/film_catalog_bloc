part of 'login_bloc.dart';

enum AuthStat { notFound, alreadyExist, undefined, inProgress, success }

final class LoginState extends Equatable {
  const LoginState( {
    this.status = FormzSubmissionStatus.initial,
    this.authStat = AuthStat.undefined,
    this.email = const Username.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.register = false,
    this.isInSubmittingProgress = false,
  });

  final FormzSubmissionStatus status;
  final Username email;
  final Password password;
  final bool isValid;
  final AuthStat authStat;
  final bool register;
  final bool isInSubmittingProgress;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    bool? isValid,
    AuthStat? authStat,
    bool? register,
    bool? isInSubmittingProgress
  }) {
    return LoginState(
      status: status ?? this.status,
      email: username ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      authStat: authStat ?? this.authStat,
      register: register ?? this.register,
      isInSubmittingProgress: isInSubmittingProgress ?? this.isInSubmittingProgress
    );
  }

  @override
  List<Object> get props =>
      [status, email, password, isValid, authStat, register,isInSubmittingProgress];
}
