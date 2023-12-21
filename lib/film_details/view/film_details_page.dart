import 'package:film_catalog_bloc/film_details/bloc/local_film_bloc.dart';
import 'package:film_catalog_bloc/film_manager/bloc/film_bloc.dart';
import 'package:film_catalog_bloc/film_manager/model/credits.dart';
import 'package:film_catalog_bloc/film_manager/model/film.dart';
import 'package:film_catalog_bloc/splash/splash.dart';
import 'package:film_catalog_bloc/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

import '../../film_manager/model/film_details.dart';
import '../../repositories/api_repository/film_api.dart';


const String defaultImage =
    'https://images.unsplash.com/photo-1598899134739-24c46f58b8c0?q=80&w=1756&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

class FilmDetailsPage extends StatefulWidget {
  const FilmDetailsPage({super.key});

  @override
  State<FilmDetailsPage> createState() => _FilmDetailsPageState();
}

class _FilmDetailsPageState extends State<FilmDetailsPage> {
  late FilmDetails? film;
  late var sampleBloc;

  @override
  void initState() {
    super.initState();
  }

  //sampleBloc.add(FilmsStatusChanged.withId(APIStatus.loadingFilmDetails, id));

  late int? id;
  FilmDetails _details = FilmDetails.empty();
  @override
  Widget build(BuildContext context) {
    sampleBloc = BlocProvider.of<FilmBloc>(context);
    id = ModalRoute.of(context)!.settings.arguments as int?;
    return MultiBlocProvider(
  providers: [
    BlocProvider.value(
      value: BlocProvider.of<FilmBloc>(context)
        ..add(FilmsStatusChanged.withId(APIStatus.loadingFilmDetails, id)),
),
    BlocProvider(
      create: (context) => LocalFilmBloc()..add(CheckFilmExist()),
    ),
  ],
  child: const LocalFilmsCheck(),
);

/*
    BlocListener<FilmBloc, FilmState>(
      listener: (context, state) {
        switch (state.status) {
          case APIStatus.filmDetailsLoaded:
            _details = state.filmDetails;
            /*FilmDetailsWidget(
                maskingGradient: _maskingGradient, film: state.filmDetails);*/
          case APIStatus.loadingFilmDetails:
            const Center(child: CircularProgressIndicator());
          case APIStatus.popularFilmsLoaded:
          case APIStatus.error:
            Center(
                child: Text('Error',
                    style: Theme.of(context).textTheme.titleMedium));
          case APIStatus.unknown:
            const Center(child: Center(child: CircularProgressIndicator()));
          case APIStatus.empty:
            const Center(child: Text('empty'));
          case APIStatus.loadingPopularFilms: // todo another
        }
      },
    child:FilmDetailsWidget(
        maskingGradient: _maskingGradient, film: _details),
    );*/
  }
}

class DetailsMain extends StatelessWidget {
  const DetailsMain({
    super.key,
    required Gradient maskingGradient,
  }) : _maskingGradient = maskingGradient;

  final Gradient _maskingGradient;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilmBloc, FilmState>(
          //todo redo
          builder: (context, state) {
            if (state.status case APIStatus.filmDetailsLoaded) {
              BlocProvider.of<LocalFilmBloc>(context)..add(SaveDataEvent(state.filmDetails));
              return FilmDetailsWidget(
                  maskingGradient: _maskingGradient, film: state.filmDetails);
            } else if (state.status case APIStatus.loadingFilmDetails) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status case APIStatus.error) {
              return Center(
                  child: Text('Error',
                      style: Theme.of(context).textTheme.titleMedium));
            } else if (state.status case APIStatus.unknown) {
              return const Center(
                  child: Center(child: CircularProgressIndicator()));
            } else {
              return const Center(child: Text('empty'));
            }
          },
        );
  }
}


class LocalFilmsCheck extends StatelessWidget { // todo converted not a prob
  const LocalFilmsCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalFilmBloc, LocalFilmState>(
      builder: (context, state) {
        if (state is FilmLoadedState){
          return FilmDetailsWidget(
              maskingGradient: maskingGradient(), film: state.filmDetails);
        }
        if(state is FileExistState && state.exist == true){
          context.read<LocalFilmBloc>().add(LoadDataEvent());
          return const SplashPage();
        }
        if(state is FileExistState && state.exist == false){
          return DetailsMain(maskingGradient: maskingGradient());
        }
        if (state is FilmLoadedState){
          return FilmDetailsWidget(
              maskingGradient: maskingGradient(), film: state.filmDetails);
        }
        //todo error view
          return Text('Local storage Error ☹',style: Theme.of(context).textTheme.displayLarge,);
      }
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopFilmDetailsImage(
                  maskingGradient: _maskingGradient,
                  filmBackgroundImg: film!.backdropPath!),
              FilmDetailsInfo(film: film),
              CreditsSection(
                credits: film!.credits,
              ),
              FeedbackButtons(),
              ListFilmDetailsPages(similar: film!.similar),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(182, 210, 202, 80),
        //todo
        foregroundColor: const Color.fromARGB(255, 5, 9, 55),
        elevation: 1,
        child: const Icon(Icons.arrow_back_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

class CollectPersonalInfoPage extends StatelessWidget {
  const CollectPersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headlineMedium!,
      child: GestureDetector(
        onTap: () {
          // This moves from the personal info page to the credentials page,
          // replacing this page with that one.
          Navigator.of(context)
              .pushReplacementNamed('signup/choose_credentials');
        },
        child: Container(
          color: Colors.lightBlue,
          alignment: Alignment.center,
          child: const Text('Collect Personal Info Page'),
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
          child: /*NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is UserScrollNotification) {
                ViewModel.getFilmDetailsPagesPoster(appState.generateRandomFilmDetailsPage())
                    .then((value) {
                  if (value.isNotEmpty) {
                    appState.addPosters(value);
                  }
                });
              }
              return true;
            },
            child: */
              ListView(
            padding:
                const EdgeInsets.only(right: 8, top: 17, bottom: 20, left: 8),
            // itemCount: 1,
            scrollDirection: Axis.horizontal,
            children: [
              for (var film in _similar)
                Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          film.posterPath ?? defaultImage,
                          //height: 200,
                          //width: 100,
                          fit: BoxFit.fill,
                        ))),
            ],
          ),
          //),
        ),
      ],
    );
  }
}

class FeedbackButtons extends StatelessWidget {
  const FeedbackButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const pad = 6.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {},
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
            child: const Column(
              children: [
                Icon(Icons.add),
                SizedBox(
                  height: pad,
                ),
                Text("My List")
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
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
            child: const Column(
              children: [
                Icon(Icons.thumb_up),
                SizedBox(
                  height: pad,
                ),
                Text("Rate")
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
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
        ],
      ),
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
          text: TextSpan(
            // text: "Cast: ",
            style: const TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w300),
            children: [
              const TextSpan(
                  text: 'Cast: ', style: TextStyle(color: Colors.black38)),
              TextSpan(
                text: _credits.cast.toString(),
              ),
              const TextSpan(
                  text: '\nDirectors: ',
                  style: TextStyle(color: Colors.black38)),
              TextSpan(
                  text: '${_credits.director}, ${_credits.coDirector ?? " "}'),
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
              child: Image.network(
                _film.posterPath!,
                // height: 230,
                width: MediaQuery.of(context).size.width / 3 - 11,
                fit: BoxFit.fill,
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
                        text: '\u2981',
                        style: TextStyle(color: Color.fromARGB(255, 120, 132, 192)),
                      ),
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
            Text(
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              _film.title!,
              style: const TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  wordSpacing: 1,
                  letterSpacing: 1),
            ),
            StarRating(
              rating: _film.voteAverage ?? 0, //todo 10 bal range
              //onRatingChanged: (rating) => setState(() => this.rating = rating),
            ),
            Container(
              //width: 300,
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 166),
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: RichText(
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _film.overview ?? " ",
                      ),
                      TextSpan(
                        text: "More...", //todo More info
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                "https://uk.wikipedia.org/wiki/%D0%A3_%D0%BF%D0%BE%D1%88%D1%83%D0%BA%D0%B0%D1%85_%D0%94%D0%BE%D1%80%D1%96"));
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
  })  : _maskingGradient = maskingGradient,
        _filmBackgroundImg = filmBackgroundImg;

  final Gradient _maskingGradient;
  final String _filmBackgroundImg;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(_filmBackgroundImg), fit: BoxFit.cover),
        ),
        child: const Icon(Icons.play_circle_outline,
            color: Colors.white, size: 110), //todo Play
      ),
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;

  // final RatingChangeCallback onRatingChanged;

  StarRating({
    this.starCount = 5,
    this.rating = .0,
    /* required this.onRatingChanged,*/
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;

    if (index >= rating) {
      icon = const Icon(
        Icons.star_border,
        color: Color.fromARGB(255, 255, 190, 29),
      );
    } else if (index > rating - 1 && index < rating) {
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
    return GestureDetector(
      onTap: () => (index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}
