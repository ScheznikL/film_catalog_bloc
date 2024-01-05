import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'film_share_event.dart';
part 'film_share_state.dart';

class FilmShareBloc extends Bloc<FilmShareEvent, FilmShareState> {
  FilmShareBloc() : super(InitialState()) {

    on<ShareFilm>((event, emit) async {
      try {
        await _saveToClipBoard(event.videoUrl);
        emit(FilmShared("Url of: ${event.title} copied to clipboard!"));
      }
      catch(e){
        emit(FilmShared("Error occurred while copping to clipboard. \n ${e.toString()}"));
      }
    });
  }

  Future<void> _saveToClipBoard(String videoUrl ) async{
    await Clipboard.setData(ClipboardData(text: videoUrl));
  }
}
