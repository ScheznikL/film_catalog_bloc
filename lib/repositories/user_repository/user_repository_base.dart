import 'dart:async';

import 'models/user.dart';

class UserRepository {
  User? _user;

  Future<User?> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
        () => _user = User(id:"",login: "",password: ""),
          //(await ) => _user = User.fromJson(json), // todo
    );
  }
}
