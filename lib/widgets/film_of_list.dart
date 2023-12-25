import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../film_manager/model/film.dart';


class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.film,
  });

  final Film film;

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/filmdetails',
          arguments: film.id,
        );
      },
      child: Container(
        padding: EdgeInsets.all(4),
        color:Theme.of(context).primaryColor,
        height: 140,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: film.posterPath,
              height: 120,
              width: 80,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        film.title ?? "",
                        style: textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color:  Color.fromARGB(255, 255, 190, 29), size: 14),
                          SizedBox(width: 4),
                          Text(film.voteAverage.toString(),
                              style: textTheme.bodyLarge),
                          SizedBox(width: 10),
                          Text(
                            film.releaseDate.toString(),
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    film.overview ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
