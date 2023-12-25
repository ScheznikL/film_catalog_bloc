import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../repositories/authentication_repository/authentication_repository_base.dart';
import '../../util/exeptions.dart';
import '../models/password.dart';
import '../models/username.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<AuthModeChange>(_onAuthModeChange);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onAuthModeChange(
    AuthModeChange event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      authStat: event.authStat,
      register: event.register,
    ));
  }

  void _onUsernameChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([state.password, username]),
        authStat: AuthStat.undefined,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email]),
        authStat: AuthStat.undefined,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.inProgress,
          authStat: AuthStat.inProgress,
          isInSubmittingProgress: true));
      try {
        await _authenticationRepository.logIn(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(
            status: FormzSubmissionStatus.success, authStat: AuthStat.success, isInSubmittingProgress: false));
      } catch (e) {
        if (e is UserNotFound) {
          emit(state.copyWith(
            status: FormzSubmissionStatus.failure,
            authStat: AuthStat
                .notFound,
              /*isInSubmittingProgress: false,*//*username: Username.dirty(e?.cause?.login ?? "")*/
          ));
        } else {
          emit(state.copyWith(status: FormzSubmissionStatus.failure, isInSubmittingProgress: false));
        }
      }
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.inProgress,
          authStat: AuthStat.inProgress,));
      try {
        await _authenticationRepository.registerUser(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(
            status: FormzSubmissionStatus.success,
            authStat: AuthStat.success,
            ));
      } catch (e) {
        if (e is UserAlreadyExist) {
          emit(state.copyWith(
              status: FormzSubmissionStatus.failure,
              authStat: AuthStat.alreadyExist,
             ));
        } else {
          emit(state.copyWith(
              status: FormzSubmissionStatus.failure,
              ));
        }
      }
    }
  }
}
