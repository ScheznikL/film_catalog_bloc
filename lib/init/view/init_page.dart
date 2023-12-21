import 'package:film_catalog_bloc/film_manager/bloc/film_bloc.dart';
import 'package:film_catalog_bloc/repositories/api_repository/film_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/binding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/view/auth_page.dart';
import '../../film_manager/model/film.dart';
import '../../widgets/user_drawer_header.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({
    this.popularFilms,
    super.key,
  });

  final List<Film>? popularFilms;

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const InitialPage());
  }

  @override
  State<InitialPage> createState() => _InitialPageState(popularFilms);
}

class _InitialPageState extends State<InitialPage> {
  _InitialPageState(this.popularFilms);

  var currentPage = DrawerSelection.main;
  final List<Film>? popularFilms;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* drawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserHeader(),
              UserDrawerList(),
            ],
          ),
        ),
      ),*/
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Popular Films"),
      ),
      body: Column(
        children: [
          /* Expanded(
            flex: 1,
            child: Container(
              child: Placeholder(), // todo add buttons
            ),
          ),*/
          Expanded(
            flex: 10,
            child: FilmsBuilder(popularFilms: popularFilms),
          ),
        ],
      ),
    );
  }

  Widget UserDrawerList() {
    return Container(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            menuItem(0, "Main page", Icons.dashboard_outlined,
                currentPage == DrawerSelection.main ? true : false),
            menuItem(1, "My cabinet", Icons.face,
                currentPage == DrawerSelection.main ? true : false),
            menuItem(2, "My likes", Icons.thumb_up,
                currentPage == DrawerSelection.main ? true : false),
            menuItem(3, "My list", Icons.checklist,
                currentPage == DrawerSelection.main ? true : false),
          ],
        ));
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.transparent : Colors.grey[300],
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            switch (id) {
              case 0:
                currentPage = DrawerSelection.main;
                break;
              case 1:
                currentPage = DrawerSelection.cabinet;
                break;
              case 2:
                currentPage = DrawerSelection.likes;
                break;
              case 3:
                currentPage = DrawerSelection.list;
                break;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
          ),
        ),
      ),
    );
  }
}

enum DrawerSelection { main, cabinet, likes, list, ratings }

class FilmsBuilder extends StatelessWidget {
  const FilmsBuilder({
    super.key,
    required this.popularFilms,
  });

  final List<Film>? popularFilms;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilmBloc, FilmState>(builder: (context, state) {
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 380,
            // childAspectRatio: 1,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            crossAxisCount: 2,
          ),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                //todo FilmDetail

                Navigator.pushNamed(
                  context,
                  '/filmdetails',
                  arguments: popularFilms![index].id,
                );
              },
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 13.0, left: 13),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            popularFilms![index].posterPath ?? "",
                            fit: BoxFit.fill,
                          ))),
                  Text(
                    '${popularFilms![index].title}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  Text(
                    'Rating: ${popularFilms![index].voteCount}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            );
          });
    });
  }
}
