import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'popular_films_event.dart';
part 'popular_films_state.dart';

class PopularFilmsBloc extends Bloc<PopularFilmsEvent, PopularFilmsState> {
  PopularFilmsBloc() : super(PopularFilmsInitial()) {
    on<PopularFilmsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
