import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_catalog_bloc/authentication/authentication.dart';
import 'package:film_catalog_bloc/login/view/auth_page.dart';
import 'package:film_catalog_bloc/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../film_manager/model/film.dart';
import '../../login/bloc/login_bloc.dart';
import '../../repositories/authentication_repository/authentication_repository_base.dart';
import '../bloc/user_lists_bloc.dart';

class UserCabinetPage extends StatelessWidget {
  const UserCabinetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 2250));
            },
            backgroundColor: Theme.of(context).colorScheme.background,
            color: Colors.white,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 10),
                ProfilePageUserProfile(),

                /* const ProfilePageLists(),
                const SizedBox(height: 40),
                const ProfilePageSettings(),
                const SizedBox(height: 40),
                const ProfilePageSocials(),
                const SizedBox(height: 40),*/
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfilePageUserProfile extends StatelessWidget {
  ProfilePageUserProfile({Key? key}) : super(key: key);
  bool pressedLogout = false;

  @override
  Widget build(BuildContext context) {
    List<Film> favouriteFilms =
        BlocProvider.of<UserListBloc>(context).likedFilms;
    List<Film> filmsToWatch =
        BlocProvider.of<UserListBloc>(context).filmsToWatch;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        color: Theme.of(context).focusColor,
                        padding: const EdgeInsets.all(10),
                        child: Center(
                            child: IconButton(
                          icon: Icon(Icons.person),
                          onPressed: () {
                            if (pressedLogout) {
                             /* BlocProvider.of<LoginBloc>(context)
                                  .add(const AuthModeChange(register: false, authStat: AuthStat.undefined));
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(const AuthenticationStatusChanged(AuthenticationStatus.unauthenticated(status: AuthenticationProgress.unauthenticated)));*/
                              getAuthPageWithOutAnimation(
                                context: context,
                              );
                            }
                          },
                        ))),
                    Container(
                        color: Theme.of(context).focusColor,
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: IconButton(
                              onPressed: () {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(AuthenticationLogoutRequested());
                                BlocProvider.of<LoginBloc>(context)
                                    .add(const LoginEmailChanged(""));
                                BlocProvider.of<UserListBloc>(context)
                                    .add(const UserListsClearAll());
                                pressedLogout = true;
                              },
                              icon: const Icon(Icons.logout)),
                        ))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 25),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(25)),
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text(
                          state.email.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: ListHorizontalFilmTile(
                              films: favouriteFilms, title: 'Liked Films'),
                        ),
                        Divider(height: 5),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: ListHorizontalFilmTile(
                              films: filmsToWatch, title: 'You Films List'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ListHorizontalFilmTile extends StatelessWidget {
  const ListHorizontalFilmTile({
    super.key,
    required this.films,
    required this.title,
  });

  final List<Film> films;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.black38),
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            itemCount: films.length,
            //controller: ,
            padding:
                const EdgeInsets.only(right: 8, top: 17, bottom: 20, left: 8),
            // itemCount: 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/filmdetails',
                    arguments: films[index].id,
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: films[index].posterPath,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
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
