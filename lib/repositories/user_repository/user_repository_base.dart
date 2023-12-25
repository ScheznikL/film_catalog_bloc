import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:film_catalog_bloc/film_manager/model/film.dart';
import 'package:film_catalog_bloc/repositories/user_repository/models/user_data.dart';
import 'package:path_provider/path_provider.dart';

import 'models/user.dart';

class UserRepository {
  static User? _user;

  Future<UserData?> getUserData(User user) async {
    _user = user;
    final file = await _getLocalFile(user.login);
    final fileLength = await file.length();
    if (fileLength > 0) {
      String? fileContent = await file.readAsString();
      Map<String, dynamic>? json =
          jsonDecode(fileContent) as Map<String, dynamic>?;

      return json != null ? UserData.fromJson(json) : UserData.empty;
    } else {
      return UserData.empty;
    }
  }

  void clearUser() => _user = null;

  Future<UserData> initUserData(User user) async {
    //if (_user == null) return null;
    try {
      final file = await _getLocalFile(user.login);
      final fileLength = await file.create();

      return UserData.empty;
    } catch (e) {
      rethrow;
    }

    /*
    return Future.delayed(
      const Duration(milliseconds: 100),
      () => UserData.empty,
    );*/
  }

  Future<bool> saveUserData(UserData userData) async {
    try {
      _user != null;
      final file = await _getLocalFile(_user!.login);

      var jsonData = userData.toJson();
      await file.writeAsString(jsonEncode(jsonData), mode: FileMode.append);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserData(UserData toUpdate) async {
    try {
      _user != null;
      final file = await _getLocalFile(_user!.login);

      var jsonData = toUpdate.toJson();
      await file.writeAsString(jsonEncode(jsonData));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<File> _getLocalFile(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_info_$email.json');
  }
}
