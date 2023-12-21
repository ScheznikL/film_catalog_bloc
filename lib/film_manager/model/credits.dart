import 'package:equatable/equatable.dart';

import 'cast.dart';

class Credits extends Equatable {
  final List<Cast> cast;
  final String director;
  final String? coDirector;

  const Credits({
    required this.cast,
    required this.director,
    required this.coDirector,
  });

  const Credits.empty()
      : cast = const [],
        director = '',
        coDirector = '';

  @override
  List<Object?> get props => [
    cast,
    director,
    coDirector,
  ];


  @override
  String toString() {
    return cast.map((person) => person.name).join(' ');
  }

  factory Credits.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('cast') && json.containsKey('crew')) {
      return Credits(
      cast: List.from(json['cast']).map((entry) => Cast.fromJson(entry)).toList(),
      coDirector:List.from(json['crew']).firstWhere((x) =>  x['job'] == 'Co-Director', orElse: () => {'name': null})['name'] ??  'N/A',
      director: List.from(json['crew']).firstWhere((x) =>  x['job'] == 'Director', orElse: () => {'name': null})['name'],
      );
      }
      return Credits.empty();
    }

    /*
    String director = List.from(this['crew']).firstWhere((x) =>  x['job'] == 'Director')['name'] ??  'N/A';
    String coDirector = List.from(this['crew']).firstWhere((x) =>  x['job'] == 'Co-Director')['name'] ??  'N/A';
    return Credits(
    cast: this['cast'],
    director: director,
    coDirector: coDirector);
    }
      cast: map['cast'] as List<Cast>,
      director: map['director'] as String,
      coDirector: map['coDirector'] as String,
    );
  }*/
}

