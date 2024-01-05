import 'package:film_catalog_bloc/film_details/view/film_details_page.dart';
import 'package:film_catalog_bloc/film_manager/bloc/film_bloc.dart';
import 'package:film_catalog_bloc/login/bloc/login_bloc.dart';
import 'package:film_catalog_bloc/repositories/api_repository/film_api.dart';
import 'package:film_catalog_bloc/repositories/authentication_repository/authentication_repository_base.dart';
import 'package:film_catalog_bloc/repositories/user_repository/user_repository_base.dart';
import 'package:film_catalog_bloc/splash/view/splash_page.dart';
import 'package:film_catalog_bloc/theme/theme.dart';
import 'package:film_catalog_bloc/user_interaction/bloc/user_lists_bloc.dart';
import 'package:film_catalog_bloc/user_interaction/cabinet/user_cabinet.dart';
import 'package:film_catalog_bloc/user_interaction/likes/likes_list.dart';
import 'package:film_catalog_bloc/user_interaction/watch/watch_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'init/view/init_page.dart';
import 'login/view/auth_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  late final FilmAPIRepository _filmAPIRepository;
  AnimationController? _animationController;
  Animation<double>? _animation;



  var navigatorKey;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
    _filmAPIRepository = FilmAPIRepository();
    navigatorKey = GlobalKey<NavigatorState>();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.fastOutSlowIn));
  }


  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _filmAPIRepository),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthenticationBloc(
                authenticationRepository: _authenticationRepository,
                userRepository: _userRepository,
              ),
            ),
            BlocProvider(
              create: (_) => LoginBloc(
                authenticationRepository: _authenticationRepository,
              ),
            ),
            BlocProvider(
              create: (_) => UserListBloc(userRepository: _userRepository),
            ),
            BlocProvider(
              create: (_) => FilmBloc(
                filmAPIRepository: _filmAPIRepository,
              )..add(const FilmsStatusChanged(APIStatus.loadingPopularFilms)),
            ),
          ],
          child: MaterialApp(
            title: 'Film Catalog',
            theme: themeIndigo(),
            navigatorKey: navigatorKey,
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) =>
                  AppView(animationController: _animationController!),
              '/signup': (BuildContext context) => const AuthorizationPage(),
              '/filmdetails': (BuildContext context) => FilmDetailsPage(),
              '/watchlist': (BuildContext context) => WatchListPage(),
              '/favourites': (BuildContext context) => FavouritesListPage(),
              '/cabinet': (BuildContext context) => UserCabinetPage(),
            },
            onGenerateRoute: (_) => SplashLoad.route(),
            // home: AppView(navigatorKey: navigatorKey),
          )),
    );
  }
}

/*
onGenerateRoute: (settings) {
  if (settings.name == "/someRoute") {
    return PageRouteBuilder(
      settings: settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
      pageBuilder: (_, __, ___) => SomePage(),
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)
    );
  }
  // Unknown route
  return MaterialPageRoute(builder: (_) => UnknownPage());
}
 */

class AppView extends StatelessWidget {
  // todo converted not a prob
  const AppView({super.key, required this.animationController});
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        /*switch (state.status) {
          case AuthenticationProgress.unknown:
            break;
          case AuthenticationProgress.authenticated:
          /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              getAuthPage(context: context);
            });*/
            var temp = 1;
            break;
          case AuthenticationProgress.unauthenticated:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              getAuthPage(context: context,controller: animationController);
            });
            break;
          case AuthenticationProgress.alreadyExist:
            break;
          case AuthenticationProgress.error:
            if(state.message != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                getAuthPage(context: context, errorMessage: state.message, controller: animationController);
              });
            }
            break;
          case AuthenticationProgress.noUserFound:
          /*ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('No such user found')),
              );*/
            break;
          case AuthenticationProgress.registered:
            break;
          case AuthenticationProgress.userinit:
          // TODO: Handle this case.
        }*/
        if (state.status case AuthenticationProgress.unauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            getAuthPage(context: context, controller: animationController);
          });
        }
        /* else if (state.status case AuthenticationProgress.error) {
          if(state.message != null) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              getAuthPage(context: context, errorMessage: state.message, controller: animationController);
            });
          }
        }*/
      },
      child: _PopularFilms(),
    );
  }
}

class _PopularFilms extends StatefulWidget {
  @override
  State<_PopularFilms> createState() => _PopularFilmsState();
}

class _PopularFilmsState extends State<_PopularFilms> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilmBloc, FilmState>(builder: (context, state) {
      if (state.status case APIStatus.loadingPopularFilms) {
        return const Center(child: SplashLoad());
      } else if (state.status case APIStatus.popularFilmsLoaded) {
        return const InitialPage(/**/);
      } else if (state.status case APIStatus.error) {
        return Center(
            child:
                Text('Error', style: Theme.of(context).textTheme.titleMedium));
      } else if (state.status case APIStatus.unknown) {
        return const Center(
            child: SplashLoad());
      } else if (state.status case APIStatus.empty) {
        return const Center(child: Text('empty'));
      } else if (state.status case APIStatus.loadingFilmDetails) {
        return const Center(child: Text('Error'));
      }
      return InitialPage(
          /**/); /*const Center(child: CircularProgressIndicator());*/
    });
  }
}
