import '../repositories/user_repository/models/user.dart';

class UserNotFound implements Exception {
  User cause;
  UserNotFound(this.cause);
}

class InvalidPassword implements Exception {
  User cause;
  InvalidPassword(this.cause);
}

class UserAlreadyExist implements Exception {
  User cause;
  UserAlreadyExist(this.cause);
}

