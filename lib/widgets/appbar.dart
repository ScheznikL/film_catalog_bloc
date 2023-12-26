import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Film Catalog"),
      //leading: Icon(Icons.menu),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/favourites',
            );
          },
        ),
       /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              icon: const Icon(Icons.star_rate),
              onPressed: () => Navigator.pushNamed(
                context,
                '/favourites',
              ),
            )),*/
        IconButton(
          icon: const Icon(Icons.bookmark_outlined),
          onPressed: () => Navigator.pushNamed(
            context,
            '/watchlist',
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => Navigator.pushNamed(
            context,
            '/cabinet',
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
