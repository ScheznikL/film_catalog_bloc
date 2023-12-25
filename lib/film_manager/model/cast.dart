import 'package:equatable/equatable.dart';
import 'package:film_catalog_bloc/film_manager/model/credits.dart';

class Cast extends Equatable {
  final String name;
  final String profilePath;
  final String character;

  const Cast({
    required this.name,
    required this.profilePath,
    required this.character,
  });

  @override
  List<Object?> get props => [
    name,
    profilePath,
    character,
  ];

  @override
  String toString() {
    return '{$name}';
  }

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'] ?? "",
      profilePath: json['profile_path'] ?? "",
      character: json['character'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profilePath': profilePath,
      'character': character,
    };
  }


}