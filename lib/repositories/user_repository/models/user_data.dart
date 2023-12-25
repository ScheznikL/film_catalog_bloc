import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../film_manager/model/film.dart';
import 'package:flutter/foundation.dart';

part 'user_data.freezed.dart';

part 'user_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class UserData with _$UserData {
  const factory UserData({
    required List<Film> liked,
    required List<Film> toWatch}) = _UserData;

  static const empty = UserData(liked: <Film>[],toWatch: <Film>[]);

  factory UserData.fromJson(Map<String, Object?> json)
  => _$UserDataFromJson(json);
}
