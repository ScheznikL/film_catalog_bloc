import 'package:film_catalog_bloc/login/view/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/bloc/login_bloc.dart';

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
            child: const Text('Register'),
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
