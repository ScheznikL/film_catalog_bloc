import 'package:film_catalog_bloc/film_manager/bloc/film_bloc.dart';
import 'package:film_catalog_bloc/repositories/api_repository/film_api.dart';
import 'package:film_catalog_bloc/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/binding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../login/view/auth_page.dart';
import '../../film_manager/model/film.dart';
import '../../util/dialogs.dart';
import '../../widgets/appbar.dart';
import '../../widgets/user_drawer_header.dart';
import '../bloc/popular_films_bloc.dart';

enum DrawerSelection { main, cabinet, likes, list, ratings }

class InitialPage extends StatefulWidget {
  const InitialPage({
    //this.popularFilms,
    super.key,
  });

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> with TickerProviderStateMixin{
  _InitialPageState();

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.fastOutSlowIn));
  }

  @override
  Widget build(BuildContext context) {
    var filmBloc = BlocProvider.of<FilmBloc>(context);
    return BlocProvider(
      create: (context) =>
          PopularFilmsBloc(filmsBloc: filmBloc)..add(FilmFetched()),
      child: const Scaffold(
        appBar: CustomAppbar(),
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: FilmsBuilder(),
            ),
          ],
        ),
      ),
    );
  }
}


class FilmsBuilder extends StatefulWidget {
  const FilmsBuilder({
    super.key,
    //   required this.popularFilms,
  });

  @override
  State<FilmsBuilder> createState() => _FilmsBuilderState();
}

class _FilmsBuilderState extends State<FilmsBuilder> {
  final _scrollController = ScrollController();
  //late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    /*_controller = YoutubePlayerController(
      initialVideoId: '4AoFA19gbLo',
      flags: const YoutubePlayerFlags(
        mute: true,
      ),
    );*/
  }


  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularFilmsBloc, PopularFilmsState>(
        builder: (context, state) {
      return GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 380,
            // childAspectRatio: 1,
            // mainAxisSpacing: 1,
            crossAxisSpacing: 4,
            crossAxisCount: 2,
          ),
          itemCount: state.films.length,
          itemBuilder: (BuildContext context, int index) {
            return _GridItemFromBlocs(
              index: index,
              state: state,
             // controller: _controller,
            );
          });
    });
  }

  void _onScroll() {
    if (_isBottom) context.read<PopularFilmsBloc>().add(FilmFetched());
  }

  bool get _isBottom {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        return true;
      }
    }
    return false;
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class _GridItemFromBlocs extends StatelessWidget {
  const _GridItemFromBlocs({required this.state, required this.index, /*required this.controller*/});

  final PopularFilmsState state;
  final int index;
  //final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case PopularFilmsStatus.failure:
        return const Center(child: Text('failed to fetch'));
      case PopularFilmsStatus.success:
        if (state.films.isEmpty) {
          return const Center(child: Text('fetching error'));
        }
        return PopularFilmContent(
          popularFilm: state.films[index],/*controller: controller,*/
        );
      case PopularFilmsStatus.initial:
        return PopularFilmContent(
          popularFilm: state.films[index],/*controller: controller*/
        );
    }
  }
}

class PopularFilmContent extends StatelessWidget {
  const PopularFilmContent({
    super.key,
    required this.popularFilm,
  //  required this.controller
  });

  final Film popularFilm;
  //final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        getFilmVideo(context: context, filmId: popularFilm.id, /*controller: controller*/);
    },
      onTap: () {
        Navigator.pushNamed(
          context,
          '/filmdetails',
          arguments: popularFilm.id,
        );
      },
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 13.0, left: 13, top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    popularFilm.posterPath ?? "",
                    fit: BoxFit.fill,
                  ))),
          Text(
            '${popularFilm.title}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          Text(
            'Rating: ${popularFilm.voteCount}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
