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
}

