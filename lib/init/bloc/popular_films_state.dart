part of 'popular_films_bloc.dart';

enum PopularFilmsStatus { initial, success, failure }


class PopularFilmsState extends Equatable{
  final List<Film> films;
  final PopularFilmsStatus status;
  final bool hasReachedMax;

  const PopularFilmsState({
    this.status = PopularFilmsStatus.initial,
    this.films = const <Film>[],
    this.hasReachedMax = false,
  });

  PopularFilmsState copyWith({
    PopularFilmsStatus? status,
    List<Film>? films,
    bool? hasReachedMax,
  }) {
    return PopularFilmsState(
      status: status ?? this.status,
      films: films ?? this.films,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [films, status, hasReachedMax];
}


