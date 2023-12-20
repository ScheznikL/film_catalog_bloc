import 'package:film_catalog_bloc/user_lists/bloc/film_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../film_manager/model/film.dart';

class WatchList extends StatefulWidget {
  final Film? film;
  const WatchList({this.film, super.key});
  @override
  State<WatchList> createState() => _WatchListState(film: film);
}

class _WatchListState extends State<WatchList> {
  _WatchListState({this.film});

  final Film? film;
  @override
  Widget build(BuildContext context) {
    //final Color color = Colors.primaries[itemNo % Colors.primaries.length];
    var watchList = BlocProvider.of<UserListBloc>(context).filmsToWatch;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          /*Navigator.pushNamed(
            context,
            ProductPage.routeName,
            arguments: Product('Product $itemNo', color),
          );*/
        },
        leading: Container(
          width: 50,
          height: 30,
          child: Placeholder(
           // color: color,
          ),
        ),
        title: Text(
          'film',
          key: Key('text_film'),
        ),
        trailing: IconButton(
          key: Key('icon_film'),
          icon: watchList.contains(film)
              ? Icon(Icons.shopping_cart)
              : Icon(Icons.shopping_cart_outlined),
          onPressed: () {
           /* !watchList.contains(film)
                ? BlocProvider.of<UserListBloc>(context).add(AddToWatchFilm(film))
                : BlocProvider.of<UserListBloc>(context).add(RemoveFromWatchFilm(film));*/
          },
        ),
      ),
    );
  }


}
