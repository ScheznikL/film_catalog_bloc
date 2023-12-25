import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../film_manager/model/film.dart';
import '../../splash/view/splash_page.dart';
import '../../widgets/appbar.dart';
import '../../widgets/film_of_list.dart';
import '../bloc/user_lists_bloc.dart';

class WatchListPage extends StatelessWidget {
  const WatchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Film> filmsToWatch = BlocProvider.of<UserListBloc>(context).filmsToWatch;
    return Scaffold(
      appBar: const CustomAppbar(),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemCount: filmsToWatch?.length ?? 1,
            itemBuilder: (context, index) {
              return filmsToWatch != null
                  ? filmsToWatch.isEmpty
                      ? const Center(
                          child: Text("You have no films to watch"),
                        )
                      : UserListTile(film: filmsToWatch[index])
                  : const SplashLoad();
            },
          );
        },
      ),
    );
  }
}
