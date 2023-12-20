import 'package:film_catalog_bloc/film_details/view/film_details_page.dart';
import 'package:film_catalog_bloc/film_manager/bloc/film_bloc.dart';
import 'package:film_catalog_bloc/repositories/api_repository/film_api.dart';
import 'package:film_catalog_bloc/repositories/authentication_repository/authentication_repository_base.dart';
import 'package:film_catalog_bloc/film_manager/model/film.dart';
import 'package:film_catalog_bloc/repositories/user_repository/user_repository_base.dart';
import 'package:film_catalog_bloc/splash/view/splash_page.dart';
import 'package:film_catalog_bloc/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'init/view/init_page.dart';
import 'login/view/auth_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  late final FilmAPIRepository _filmAPIRepository;
  var navigatorKey;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
    _filmAPIRepository = FilmAPIRepository();
    navigatorKey = GlobalKey<NavigatorState>();
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
              create: (_) => FilmBloc(
                filmAPIRepository: _filmAPIRepository,
              )..add(FilmsStatusChanged(APIStatus.loadingPopularFilms)),
            ),
          ],
          child: MaterialApp(
            title: 'Film Catalog',
            theme: themeIndigo(),
            navigatorKey: navigatorKey,
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) => const AppView(),
              '/signup': (BuildContext context) => const AuthorizationPage(),
              '/filmdetails':(BuildContext context) => const FilmDetailsPage(),
            },
            onGenerateRoute: (_) => SplashPage.route(),
            // home: AppView(navigatorKey: navigatorKey),
          )),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({this.navigatorKey, super.key});

  final GlobalKey<NavigatorState>? navigatorKey;
  @override
  State<AppView> createState() => _AppViewState();
}

/*
class _AppViewState extends State<AppView> {

  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Catalog',
     theme: themeIndigo(),
      navigatorKey: _navigator,
      builder: (context, child) {
        return BlocBuilder<FilmBloc, FilmState>(builder: (context, state) {
          switch (state.status) {
            case APIStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case APIStatus.loaded:
              return InitialPage(popularFilms: state.popularFilms);
            case APIStatus.error:
              return Center(child: Text('Error',style: Theme.of(context).textTheme.titleMedium));
            case APIStatus.unknown:
              return const Center(child: Text('unknown'));
            case APIStatus.empty:
              return const Center(child: Text('empty'));
          }
        });
      },
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const AppView(),
        '/signup': (BuildContext context) => const AuthorizationPage(),
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}*/

class _AppViewState extends State<AppView> {

  //NavigatorState get _navigator => _navigatorKey.currentState;;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            break;
          case AuthenticationStatus.unauthenticated:
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              getAuthPage(context: context);
            });
          case AuthenticationStatus.unknown:
            break;
        }
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
      switch (state.status) {
        case APIStatus.loadingPopularFilms:
          return const Center(child: CircularProgressIndicator());
        case APIStatus.loaded:
          return InitialPage(popularFilms: state.popularFilms);
        case APIStatus.error:
          return Center(
              child: Text('Error',
                  style: Theme.of(context).textTheme.titleMedium));
        case APIStatus.unknown:
          return Center(child: Text('unknown',
                  style: Theme.of(context).textTheme.titleMedium));
        case APIStatus.empty:
          return const Center(child: Text('empty'));
        case APIStatus.loadingFilmDetails: // todo another
          return const Center(child: Text('Error'));

      }
    });
  }
}
