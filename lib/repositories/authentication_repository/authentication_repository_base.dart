import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:film_catalog_bloc/repositories/user_repository/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../util/exeptions.dart';

class AuthenticationStatus extends Equatable {
  final AuthenticationProgress status;
  final User user;
  final String? message;

  @override
  List<Object?> get props => [status, user, message];

  AuthenticationStatus._({
    required this.status,
    required this.user,
    this.message,
  });

  const AuthenticationStatus.unknown()
      : status = AuthenticationProgress.unauthenticated,
        user = User.empty,
        message = "";

  /*const AuthenticationStatus.registered(
      {required this.status, required this.user, this.message = ""});*/
  const AuthenticationStatus.authenticated(
      {required this.status, required this.user, this.message = ""});

  const AuthenticationStatus.unauthenticated(
      {required this.status, this.user = User.empty, this.message = ""});

  const AuthenticationStatus.alreadyExist(
      {required this.status, required this.user, this.message = ""});

  const AuthenticationStatus.error({
    required this.status,
    this.message,
    this.user = User.empty,
  });

  const AuthenticationStatus.noUserFound(
      {required this.status, required this.user, this.message = ""});

  const AuthenticationStatus.userInit(
      {required this.status, required this.user, this.message = ""});
  const AuthenticationStatus.userObtained(
      {required this.status, required this.user, this.message = ""});
}

enum AuthenticationProgress {
  unknown,
  authenticated,
  unauthenticated,
  alreadyExist,
  error,
  noUserFound,
  registered,
  userInit,
  userObtained
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield const AuthenticationStatus.unknown();
    yield* _controller.stream;
  }

  Future<File> getLocalFile(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_$email.json');
  }

  Future<bool> userExist(File file, String email) async {
    var existFilm = await file.exists();
    if (existFilm) {
      var length = await file.length();
      return existFilm && length > 0;
    } else {
      return existFilm;
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    final file = await getLocalFile(email);
    var exist = await userExist(file, email);

    if (exist) {
      try {
        String? fileContent = await file.readAsString();
        Map<String, dynamic>? json =
        jsonDecode(fileContent) as Map<String, dynamic>?;

        if (json != null) {
          var user = User.fromJson(json);

          if (user.password == password) {
            _controller.add(AuthenticationStatus.userObtained(
                status: AuthenticationProgress.userObtained,
                user: User.fromJson(json)));
          } else {
            _controller.add(AuthenticationStatus.error(
                message: "Invalid password",
                status: AuthenticationProgress.error,
                user: user));
            throw InvalidPassword(user);
          }
        }
      } catch (e) {
        rethrow;
      }
    } else {
      _controller.add(AuthenticationStatus.noUserFound(
          status: AuthenticationProgress.noUserFound,
          user: User(id: "noId", password: password, login: email)));
      //return User.empty;
      throw UserNotFound(User(login: email, password: password, id: "noId"));
    }
  }

  void logOut() {
    _controller.add(const AuthenticationStatus.unauthenticated(
        status: AuthenticationProgress.unauthenticated));
  }

  void denied() {
    _controller.add(AuthenticationStatus.unknown());
  }

  void dispose() => _controller.close();

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final file = await getLocalFile(email);
      final present = await userExist(file, email);

      if (present) {
        _controller.add(AuthenticationStatus.alreadyExist(
            status: AuthenticationProgress.alreadyExist,
            user: User(id: "noId", password: password, login: email)));
      } else {
        User user =
        User(id: Uuid().v4().toString(), login: email, password: password);
        var jsonData = user.toJson();
        await file.writeAsString(jsonEncode(jsonData));
        _controller.add(AuthenticationStatus.userInit(
            status: AuthenticationProgress.userInit, user: user));
      }
    } catch (e) {
      _controller.add(AuthenticationStatus.error(
          status: AuthenticationProgress.error, message: e.toString()));
      throw UserNotFound(User(login: email, password: password, id: "noId"));
    }
  }
}
