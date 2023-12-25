import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../film_manager/model/film.dart';
import '../../splash/view/splash_page.dart';
import '../../widgets/appbar.dart';
import '../../widgets/film_of_list.dart';
import '../bloc/user_lists_bloc.dart';

class FavouritesListPage extends StatelessWidget {
  const FavouritesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Film> favouriteFilms = BlocProvider.of<UserListBloc>(context).likedFilms;
    return Scaffold(
      appBar: const CustomAppbar(),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemCount: favouriteFilms?.length ?? 1,
            itemBuilder: (context, index) {
              return favouriteFilms != null
                  ? favouriteFilms.isEmpty
                  ? const Center(
                child: Text("You have no favourite films"),
              )
                  : UserListTile(film: favouriteFilms[index])
                  : const SplashLoad();
            },
          );
        },
      ),
    );
  }
}
