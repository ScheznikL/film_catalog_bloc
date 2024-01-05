import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../film_details/bloc/local_film_bloc.dart';
import '../film_manager/bloc/film_bloc.dart';
import '../repositories/api_repository/film_api.dart';
import '../splash/view/splash_page.dart';

class FilmVideoWidget extends StatelessWidget {
  const FilmVideoWidget({
    super.key,
    required this.filmId,
    /*required this.controller*/
  });
  final int? filmId;
  // final YoutubePlayerController controller;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<FilmBloc>(context),
        ),
        BlocProvider(
          create: (context) =>
              LocalFilmBloc()..add(CheckFilmExist(filmId.toString())),
        ),
      ],
      child: LocalFilmsCheck(
        id: filmId.toString(), /* controller: controller*/
      ),
    );
  }
}

class FilmVideoPage extends StatefulWidget {
  const FilmVideoPage({
    super.key,
    required this.videoKey,
    this.title,
    // required this.controller,
  });

  final String videoKey;
  final String? title;
  // final YoutubePlayerController controller;
  @override
  State<FilmVideoPage> createState() =>
      _FilmVideoPageState(/*videoKey: videoKey*/);
}

class _FilmVideoPageState extends State<FilmVideoPage> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
/*
  _FilmVideoPageState({required this.videoKey});
  final String videoKey;*/

  late TextEditingController _idController;
  late TextEditingController _seekToController;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoKey,
      flags: const YoutubePlayerFlags(
        mute: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    // widget.controller.addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // widget.controller.pause();
    // widget.controller.load(widget.videoKey);
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.title ?? "",
          style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        YoutubePlayerBuilder(
          onExitFullScreen: () {
            // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          //  progressIndicatorColor: Colors.blueAccent,
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {
              Navigator.of(context).pop();
            },
          ),
          builder: (context, player) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 1),
                              bottom: BorderSide(width: 1))),
                      //padding: EdgeInsets.only(top: 10),
                      child: Text(textAlign: TextAlign.right,softWrap: true,
                        'Channel: ${_videoMetaData.author}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _playerState.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class LocalFilmsCheck extends StatelessWidget {
  final String id;
  //final YoutubePlayerController controller;

  const LocalFilmsCheck({
    required this.id,
    super.key,
    /*required this.controller*/
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalFilmBloc, LocalFilmState>(
        builder: (context, state) {
      if (state is FilmLoadedState) {
        return FilmVideoPage(
          title: state.filmDetails?.title,
          videoKey: state.filmDetails?.filmVideo?.key ?? "4AoFA19gbLo",
          // controller: controller,
        );
      }
      if (state is FileExistState && state.exist) {
        context.read<LocalFilmBloc>().add(LoadDataEvent(id));
        return const SplashLoad();
      }
      if (state is FileExistState && !state.exist) {
        BlocProvider.of<FilmBloc>(context).add(FilmsStatusChanged.withId(
            APIStatus.loadingFilmDetails, int.parse(id)));
        return LoadingDataView(/*controller: controller*/);
      }
      if (state is FilmLoadedState) {
        return FilmVideoPage(
          title: state.filmDetails?.title,
          videoKey: state.filmDetails?.filmVideo?.key ?? "4AoFA19gbLo",
          // controller: controller,
        );
      }
      if (state is LoadSaveErrorState) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Local storage Error ☹\r\n\r\n ${state.message}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      }
      if (state is FilmSavedState) {
        return LoadingDataView(/*controller: controller,*/);
      } else {
        return const SplashLoad();
      }
    });
  }
}

class LoadingDataView extends StatelessWidget {
  const LoadingDataView({
    super.key,
    //required this.controller,
  });
  // final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilmBloc, FilmState>(
      builder: (context, state) {
        if (state.status case APIStatus.loadingFilmDetails) {
          return const SplashLoad();
        }
        if (state.status case APIStatus.filmDetailsLoaded) {
          BlocProvider.of<LocalFilmBloc>(context)
              .add(SaveDataEvent(state.filmDetails));
          return FilmVideoPage(
            title: state.filmDetails?.title,
            videoKey: state.filmDetails?.filmVideo?.key ?? "4AoFA19gbLo",
            //  controller: controller,
          );
        }
        if (state.status case APIStatus.error) {
          return Center(
              child: Text('Error',
                  style: Theme.of(context).textTheme.titleMedium));
        } else {
          return const SplashLoad();
        }
      },
    );
  }
}
