import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../repositories/authentication_repository/authentication_repository_base.dart';
import '../bloc/login_bloc.dart';
import 'login_form.dart';

const logoUrl = "";
/*
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
               break;
              case AuthenticationStatus.unauthenticated:
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                          getAuthPage(context: context);
                });
              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: ,
        ),
      ),
    );
  }
}*/

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 25, right: 15.0, left: 15),
        child: Container(
          height: MediaQuery.of(context).size.height,
          //  color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.movie,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //todo Unauth
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Login",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text: " to get full access to the app",
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 19,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Column(children: [
                Container(
                  height: 45,
                  child: TextField(
                    onChanged: (input) {
                      // context.read<TextCubit>().updateText(input);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter email',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 1, color: Colors.black12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 1.5, color: Colors.black12)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 45,
                  child: TextField(
                    onChanged: (input) {
                      // context.read<TextCubit>().updateText(input);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter your password',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 1, color: Colors.black12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 1.5, color: Colors.black12)),
                    ),
                  ),
                ),
              ]),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 23.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontStyle: FontStyle.italic),
                      children: [
                        const TextSpan(
                            text: "Don't have an account - ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            )),
                        TextSpan(
                          text: "Signup",
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color.fromRGBO(13, 13, 58, 1.0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //todo
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.indigo.shade100),
                  ),
                  onPressed: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(13, 13, 58, 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> getAuthPage({required BuildContext context}) async {

  return showModalBottomSheet<void>(
    //todo
    /*transitionAnimationController: AnimationController(vsync: vsync),*/
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      //useRootNavigator: true,
      builder: (BuildContext context) {
        return const AuthorizationPage();
      });
}
