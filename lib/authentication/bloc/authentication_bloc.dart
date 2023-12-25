import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/authentication_repository/authentication_repository_base.dart';
import '../../repositories/user_repository/models/user.dart';
import '../../repositories/user_repository/models/user_data.dart';
import '../../repositories/user_repository/user_repository_base.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(AuthenticationState.unknown())
  {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationLoginDenied>(_onAuthenticationLoginDenied);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
          (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
  _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
      AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit,
      ) async {
    switch (event.status.status) {
      case AuthenticationProgress.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationProgress.userObtained:
        final userData = await _tryGetUserInfo(event.status.user);
        return emit(
          userData != null
              ? AuthenticationState.authenticated(event.status.user, userData)
              :  const AuthenticationState.unauthenticated(),
        );
      case AuthenticationProgress.unknown:
        return emit( const AuthenticationState.unknown());
      case AuthenticationProgress.alreadyExist:
        return emit( const AuthenticationState.userAlreadyExist());
      case AuthenticationProgress.error:
        return emit(AuthenticationState.error(event.status.message ?? ""));
      case AuthenticationProgress.noUserFound:
        return emit(const AuthenticationState.notFound());
      case AuthenticationProgress.userInit:
        final userData = await _tryInitUserData(event.status.user);
        return emit(
          userData != null
              ? AuthenticationState.registered(event.status.user, userData)
              :  const AuthenticationState.unauthenticated(),
        );
      case AuthenticationProgress.registered:
        // TODO: Handle this case.
      case AuthenticationProgress.authenticated:
        // TODO: Handle this case.
    }
  }

  void _onAuthenticationLogoutRequested(
      AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit,
      ) {
    _authenticationRepository.logOut();
    _userRepository.clearUser();
  }

  void _onAuthenticationLoginDenied(
      AuthenticationLoginDenied event,
      Emitter<AuthenticationState> emit) {
    _authenticationRepository.denied();
  }

  Future<UserData?> _tryGetUserInfo(User user) async {
    try {
      final userData = await _userRepository.getUserData(user);
      return userData;
    } catch (_) {
      return null;
    }
  }
    Future<UserData?> _tryInitUserData(User user) async {
    try {
      final userData = _userRepository.initUserData(user);
      return userData;
    } catch (_) {
      return null;
    }
  }



}
