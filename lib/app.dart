import 'package:film_catalog_bloc/film_details/view/film_details_page.dart';
import 'package:film_catalog_bloc/film_manager/bloc/film_bloc.dart';
import 'package:film_catalog_bloc/repositories/api_repository/film_api.dart';
import 'package:film_catalog_bloc/repositories/authentication_repository/authentication_repository_base.dart';
import 'package:film_catalog_bloc/repositories/user_repository/user_repository_base.dart';
import 'package:film_catalog_bloc/splash/view/splash_page.dart';
import 'package:film_catalog_bloc/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'init/view/init_page.dart';
import 'login/view/auth_page.dart';

// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}

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
              '/filmdetails': (BuildContext context) => FilmDetailsPage(),
            },
            onGenerateRoute: (_) => SplashPage.route(),
            // home: AppView(navigatorKey: navigatorKey),
          )),
    );
  }
}

class AppView extends StatelessWidget { // todo converted not a prob
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            break;
          case AuthenticationStatus.unauthenticated:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
      if (state.status case APIStatus.loadingPopularFilms) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status case APIStatus.popularFilmsLoaded) {
        return InitialPage(popularFilms: state.popularFilms);
      } else if (state.status case APIStatus.error) {
        return Center(
            child:
                Text('Error', style: Theme.of(context).textTheme.titleMedium));
      } else if (state.status case APIStatus.unknown) {
        return Center(
            child: Text('unknown',
                style: Theme.of(context).textTheme.titleMedium));
      } else if (state.status case APIStatus.empty) {
        return const Center(child: Text('empty'));
      } else if (state.status case APIStatus.loadingFilmDetails) {
        return const Center(child: Text('Error'));
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
