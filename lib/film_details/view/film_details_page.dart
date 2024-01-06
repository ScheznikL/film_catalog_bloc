import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_catalog_bloc/authentication/authentication.dart';
import 'package:film_catalog_bloc/film_details/bloc/local_film_bloc.dart';
import 'package:film_catalog_bloc/film_manager/bloc/film_bloc.dart';
import 'package:film_catalog_bloc/film_manager/model/credits.dart';
import 'package:film_catalog_bloc/film_manager/model/film.dart';
import 'package:film_catalog_bloc/splash/splash.dart';
import 'package:film_catalog_bloc/theme/theme.dart';
import 'package:film_catalog_bloc/util/dialogs.dart';
import 'package:film_catalog_bloc/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../film_manager/model/film_details.dart';
import '../../login/bloc/login_bloc.dart';
import '../../repositories/api_repository/film_api.dart';
import '../../user_interaction/bloc/user_lists_bloc.dart';
import '../bloc/film_share_bloc.dart';

const String defaultImage =
    'https://images.unsplash.com/photo-1598899134739-24c46f58b8c0?q=80&w=1756&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

class FilmDetailsPage extends StatefulWidget {
  const FilmDetailsPage({super.key});

  @override
  State<FilmDetailsPage> createState() => _FilmDetailsPageState();
}

class _FilmDetailsPageState extends State<FilmDetailsPage> {
  late FilmDetails? film;

  @override
  void initState() {
    super.initState();
  }

  late int? filmId;
  @override
  Widget build(BuildContext context) {
    filmId = ModalRoute.of(context)!.settings.arguments as int?;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<FilmBloc>(
              context), /*
            ..add(FilmsStatusChanged.withId(APIStatus.loadingFilmDetails, filmId)),*/
        ),
        BlocProvider(
          create: (context) =>
              LocalFilmBloc()..add(CheckFilmExist(filmId.toString())),
        ),
        BlocProvider.value(value: BlocProvider.of<UserListBloc>(context)),
        BlocProvider(create: (context) => FilmShareBloc()),
      ],
      child: LocalFilmsCheck(id: filmId.toString()),
    );
  }
}

class LocalFilmsCheck extends StatelessWidget {
  final String id;

  const LocalFilmsCheck({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalFilmBloc, LocalFilmState>(
        builder: (context, state) {
      if (state is FilmLoadedState) {
        return FilmDetailsWidget(
            maskingGradient: maskingGradient(), film: state.filmDetails);
      }
      if (state is FileExistState && state.exist) {
        context.read<LocalFilmBloc>().add(LoadDataEvent(id));
        return const SplashLoad();
      }
      if (state is FileExistState && !state.exist) {
        BlocProvider.of<FilmBloc>(context).add(FilmsStatusChanged.withId(
            APIStatus.loadingFilmDetails, int.parse(id)));
        return DetailsMain(maskingGradient: maskingGradient());
      }
      if (state is FilmLoadedState) {
        return FilmDetailsWidget(
            maskingGradient: maskingGradient(), film: state.filmDetails);
      }
      if (state is LoadSaveErrorState) {
        return Center(
          child: Text(
            'Local storage Error ☹\r\n ${state.message}',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        );
      }
      if (state is FilmSavedState) {
        return DetailsMain(maskingGradient: maskingGradient());
      } else {
        return SplashLoad();
      }
    });
  }
}

class DetailsMain extends StatelessWidget {
  const DetailsMain({
    super.key,
    required Gradient maskingGradient,
    this.filmId,
  }) : _maskingGradient = maskingGradient;

  final Gradient _maskingGradient;
  final filmId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilmBloc, FilmState>(

      builder: (context, state) {
        if (state.status case APIStatus.filmDetailsLoaded) {
          BlocProvider.of<LocalFilmBloc>(context)
              .add(SaveDataEvent(state.filmDetails));
          return FilmDetailsWidget(
              maskingGradient: _maskingGradient, film: state.filmDetails);
        }
        if (state.status case APIStatus.loadingFilmDetails) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status case APIStatus.error) {
          return Center(
              child: Text('Error',
                  style: Theme.of(context).textTheme.titleMedium));
        }
        if (state.status case APIStatus.popularFilmsLoaded) {
          // BlocProvider.of<FilmBloc>(context).add(FilmsStatusChanged.withId(APIStatus.loadingFilmDetails, filmId));
          return const Center(
              child: Center(child: CircularProgressIndicator()));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class FilmDetailsWidget extends StatelessWidget {
  const FilmDetailsWidget({
    super.key,
    required Gradient maskingGradient,
    required this.film,
  }) : _maskingGradient = maskingGradient;

  final Gradient _maskingGradient;
  final FilmDetails? film;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopFilmDetailsImage(
                  maskingGradient: _maskingGradient,
                  filmBackgroundImg: film!.backdropPath,
                  filmVidUrl: film!.filmVideo?.trailerUrl ?? ""),
              FilmDetailsInfo(film: film),
              CreditsSection(
                credits: film!.credits,
              ),
              FeedbackButtons(film: film ?? const FilmDetails.empty()),
              ListFilmDetailsPages(similar: film!.similar),
            ],
          ),
        ),
      ),
    );
  }
}

class ListFilmDetailsPages extends StatelessWidget {
  const ListFilmDetailsPages({
    super.key,
    required similar,
  }) : _similar = similar;

  final List<Film> _similar;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'SIMILAR LIKE THIS',
            style: TextStyle(color: Colors.black38),
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            itemCount: _similar.length,
            //controller: ,
            padding:
                const EdgeInsets.only(right: 8, top: 17, bottom: 20, left: 8),
            // itemCount: 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    '/filmdetails',
                    arguments: _similar[index].id,
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: _similar[index].posterPath,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => SizedBox(
                            height: 200,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.justify,
                                    _similar[index].title!),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Icon(Icons.error),
                              ],
                            )),
                      ),
                      /*Image.network(
                          _similar[index].posterPath ?? defaultImage,
                          //height: 200,
                          //width: 100,
                          fit: BoxFit.fill,
                        )*/
                    )),
              );
            },
          ),
          //),
        ),
      ],
    );
  }
}

class FeedbackButtons extends StatelessWidget {
  const FeedbackButtons({super.key, required this.film});

  final FilmDetails film;

  @override
  Widget build(BuildContext context) {
    const pad = 6.0;
    List<Film>? favouriteFilms;
    List<Film>? filmsToWatch;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        // var authenticationStatusSubscription = BlocProvider.of<AuthenticationBloc>(context).authenticationStatusSubscription;
        if (state.email.value.isNotEmpty) {
          favouriteFilms = BlocProvider.of<UserListBloc>(context).likedFilms;
          filmsToWatch = BlocProvider.of<UserListBloc>(context).filmsToWatch;
        }
        //  var st = state.userWatch;
        return BlocBuilder<UserListBloc, UserListState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      filmsToWatch != null
                          ? filmsToWatch!
                                  .where((element) => element.id == film.id)
                                  .isEmpty
                              ? context
                                  .read<UserListBloc>()
                                  .add(AddToWatchFilm(film))
                              : context
                                  .read<UserListBloc>()
                                  .add(RemoveFromWatchFilm(film))
                          : showYouHaveNoAccountDialog(
                              context: context,
                              text: "Create account to get full access.",
                              header: "You are not sign in :(");
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => const Color.fromARGB(255, 114, 114, 114)),
                      // iconColor: MaterialStateProperty.resolveWith((states) => const Color.fromARGB(255, 114, 114, 114)),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.transparent),
                      textStyle: MaterialStateProperty.resolveWith(
                        (states) => const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        filmsToWatch != null
                            ? filmsToWatch!
                                    .where((element) => element.id == film.id)
                                    .isNotEmpty
                                ? const Icon(Icons.add_circle)
                                : const Icon(Icons.add_circle_outline)
                            : const Icon(Icons.add),
                        const SizedBox(
                          height: pad,
                        ),
                        Text("My List")
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      favouriteFilms != null
                          ? favouriteFilms!
                                  .where((element) => element.id == film.id)
                                  .isEmpty
                              ? context.read<UserListBloc>().add(LikeFilm(film))
                              : context
                                  .read<UserListBloc>()
                                  .add(UnLikeFilm(film))
                          : showYouHaveNoAccountDialog(
                              context: context,
                              text: "Create account to get full access.",
                              header: "You are not sign in :(");
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => const Color.fromARGB(255, 114, 114, 114)),
                      // iconColor: MaterialStateProperty.resolveWith((states) => const Color.fromARGB(255, 114, 114, 114)),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.transparent),
                      textStyle: MaterialStateProperty.resolveWith(
                        (states) => const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        favouriteFilms != null
                            ? favouriteFilms!
                                    .where((element) => element.id == film.id)
                                    .isNotEmpty
                                ? const Icon(Icons.thumb_up)
                                : const Icon(Icons.thumb_up_alt_outlined)
                            : const Icon(Icons.thumb_up),
                        const SizedBox(
                          height: pad,
                        ),
                        const Text("Like")
                      ],
                    ),
                  ),
                  BlocListener<FilmShareBloc, FilmShareState>(
                      child: TextButton(
                        onPressed: () {
                          context.read<FilmShareBloc>().add(ShareFilm(
                              title: film.title!,
                              videoUrl: film.filmVideo?.trailerUrl ?? ""));
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith(
                              (states) =>
                                  const Color.fromARGB(255, 114, 114, 114)),
                          // iconColor: MaterialStateProperty.resolveWith((states) => const Color.fromARGB(255, 114, 114, 114)),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.transparent),
                          textStyle: MaterialStateProperty.resolveWith(
                            (states) => const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.share),
                            SizedBox(
                              height: pad,
                            ),
                            Text("Share")
                          ],
                        ),
                      ),
                      listener: (context, state) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                state is FilmShared ? state.message : "")));
                      }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CreditsSection extends StatelessWidget {
  const CreditsSection({super.key, required credits}) : _credits = credits;

  final Credits _credits;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 8),
        child: RichText(
          softWrap: true,
          text: TextSpan(
            // text: "Cast: ",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5),
            children: [
              const TextSpan(
                  text: 'Cast: ', style: TextStyle(color: Colors.black38)),
              TextSpan(
                text: _credits.cast.map((el) => el.name).join(",  "),
              ),
              const TextSpan(
                  text: '\nDirectors: ',
                  style: TextStyle(color: Colors.black38)),
              TextSpan(
                  text:
                      '${_credits.director}, ${_credits.coDirector == 'N/A' ? " " : _credits.coDirector}'),
              const WidgetSpan(
                  child: Padding(
                padding: EdgeInsets.only(bottom: 10.0, top: 16),
              )),
            ],
          ),
        ));
  }
}

class FilmDetailsInfo extends StatelessWidget {
  const FilmDetailsInfo({
    super.key,
    required film,
  }) : _film = film;

  final FilmDetails _film;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(-1, 12),
                  color: Color.fromARGB(90, 0, 0, 0),
                  spreadRadius: 5,
                  blurRadius: 20,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width / 3 - 11,
                fit: BoxFit.fill,
                imageUrl: _film.posterPath,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const SizedBox(
                    height: 200,
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.error),
                      ],
                    )),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _film.releaseDate?.year.toString(),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 120, 132, 192)),
                      ),
                      const TextSpan(
                        text: '  \u2981  ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 120, 132, 192)),
                      ),
                      TextSpan(
                          text: _film.genres
                              .map((e) {
                                if (_film.genres.length <= 3) {
                                  return e.name;
                                } else {
                                  return "";
                                }
                              })
                              .join("  ")
                              .toString(),
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color.fromARGB(255, 120, 132, 192)))
                      /* for (int i =0; i<_film.genres!.length; i++)
                        ...[
                          if(i<4)
                          TextSpan(
                            text: '${_film.genres![i].name}, ',
                          ),
                        ]*/
                    ],
                  ),
                )),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 166),
              child: Text(
                //textAlign: TextAlign.justify,
                softWrap: true,
                _film.title!,
                style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 1,
                    letterSpacing: 1),
              ),
            ),
            StarRating(
              rating: _film.voteAverage ?? 0,
              //onRatingChanged: (rating) => setState(() => this.rating = rating),
            ),
            Container(
              //width: 300,
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 166),
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: RichText(
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _film.overview ?? " ",
                      ),
                      TextSpan(
                        text: "More...",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final String url =
                                "https://www.google.com/search?q=${_film.title}+${_film.genres.firstOrNull?.name ?? 'film'}";
                            launchUrl(Uri.parse(url));
                          },
                      )
                    ],
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color.fromARGB(255, 114, 114, 114),
                    ),
                  )

                  //overflow: TextOverflow.clip,

                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class TopFilmDetailsImage extends StatelessWidget {
  const TopFilmDetailsImage({
    super.key,
    required Gradient maskingGradient,
    required String filmBackgroundImg,
    required String filmVidUrl,
  })  : _maskingGradient = maskingGradient,
        _filmBackgroundImg = filmBackgroundImg,
        _filmVidUrl = filmVidUrl;

  final Gradient _maskingGradient;
  final String _filmBackgroundImg;
  final String _filmVidUrl;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                _filmBackgroundImg,
              ),
              fit: BoxFit.cover),
        ),
        child: IconButton(
            onPressed: () {
              if (_filmVidUrl.isNotEmpty) {
                launchUrl(Uri.parse(_filmVidUrl));
              }
            },
            icon: const Icon(Icons.play_circle_outline,
                color: Colors.white, size: 110)),
      ),
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;

  // final RatingChangeCallback onRatingChanged;

  const StarRating({
    super.key,
    this.starCount = 5,
    this.rating = .0,
    /* required this.onRatingChanged,*/
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;

    if (index > rating / 2) {
      icon = const Icon(
        Icons.star_border,
        color: Color.fromARGB(255, 255, 190, 29),
      );
    } else if (index > rating / 2 - 1 && index < rating / 2) {
      icon = const Icon(
        Icons.star_half,
        color: Color.fromARGB(255, 255, 190, 29),
      );
    } else {
      icon = const Icon(
        Icons.star,
        color: Color.fromARGB(255, 255, 190, 29),
      );
    }
    if (index == 5) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          "$rating",
          style: const TextStyle(color: Color.fromARGB(255, 100, 68, 8)),
        ),
      );
    } else {
      return icon;
    }
    /*return GestureDetector(
      onTap: () => (index + 1.0),
      child: icon,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          List.generate(starCount + 1, (index) => buildStar(context, index)),
    );
  }
}
