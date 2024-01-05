import 'package:film_catalog_bloc/login/view/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../login/bloc/login_bloc.dart';
import '../widgets/film_video_widget.dart';

Future<void> showMyDialog(
    {required BuildContext context,
    required String? text,
    required String? header,
    int? numberOfButtons}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(header ?? ""),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(child: Text(text ?? "")),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.read<LoginBloc>().add(const AuthModeChange(
                  register: false, authStat: AuthStat.undefined));
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          const SizedBox(
            width: 85,
          ),
          TextButton(
            onPressed: () {
              /*   var nodetemp = Navigator.of(context);
              var temp = ModalRoute.of(context)?.currentResult; */

              context.read<LoginBloc>().add(const AuthModeChange(
                  register: true, authStat: AuthStat.undefined));
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> showAuthorisationSuccess({
  required BuildContext context,
  required String? text,
  required String? header,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(header ?? ""),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(child: Text(text ?? "")),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                context.read<LoginBloc>().add(const AuthModeChange(
                    register: true, authStat: AuthStat.undefined));
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showYouHaveNoAccountDialog(
    {required BuildContext context,
    required String? text,
    required String? header,
    int? numberOfButtons}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(header ?? ""),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(child: Text(text ?? "")),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          const SizedBox(
            width: 85,
          ),
          TextButton(
            onPressed: () {
              context.read<LoginBloc>().add(const AuthModeChange(
                  register: true, authStat: AuthStat.undefined));
              Navigator.pop(context);
              getAuthPageWithOutAnimation(
                context: context,
              );
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              context.read<LoginBloc>().add(const AuthModeChange(
                  register: false, authStat: AuthStat.undefined));
              Navigator.pop(context);
              getAuthPageWithOutAnimation(
                context: context,
              );
            },
            child: const Text('Log In'),
          )
        ],
      );
    },
  );
}

void getFilmVideo({
  required BuildContext context,
  required int? filmId,
 // required YoutubePlayerController controller
}) {
  showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    context: context,
    pageBuilder: (context, a1, a2) {
      return Center(
        child: SingleChildScrollView(
          child: Container(
            height: 270 + 70,
            width: MediaQuery.of(context).size.width - 10,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0),
              ),
              color: Theme.of(context).secondaryHeaderColor,
            ),
            child: FilmVideoWidget(filmId: filmId, /*controller: controller*/),
          ),
        ),
      );
    },
    transitionBuilder: _buildNewTransition,
    transitionDuration: const Duration(milliseconds: 100),
  );
}

Widget _buildNewTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    ) {
  return ScaleTransition(
    scale: CurvedAnimation(
      parent: animation,
      curve: Curves.bounceIn,
      reverseCurve: Curves.bounceIn,
    ),
    child: child,
  );
}
