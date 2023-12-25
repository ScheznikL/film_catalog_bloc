import 'package:film_catalog_bloc/repositories/authentication_repository/authentication_repository_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../theme/default_animation.dart';
import '../../util/dialogs.dart';
import '../bloc/login_bloc.dart';

const logoUrl = "";

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key, this.message});

  final String? message;

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final String text = controller.text.toLowerCase();
      /*controller.value = controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.status == AuthenticationProgress.error) {
              showMyDialog(
                  header: 'Something went wrong',
                  context: context,
                  text: "${state.message}");
              /*ScaffoldMessenger.of(context)..mounted
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Authentication Failure')),
          );*/
            }
            if (state.status == AuthenticationProgress.noUserFound) {
              showMyDialog(
                  header: "Something went wrong",
                  context: context,
                  text: "User not found\r\nWould you like to register?");
            }
            if (state.status == AuthenticationProgress.alreadyExist) {
              showMyDialog(
                  header: "",
                  context: context,
                  text: "${state.user.login} already exist!\r\nTry again");
              controller.value = controller.value.copyWith(
                text: "",
              );
            }
            if (state.status == AuthenticationProgress.registered) {
              showAuthorisationSuccess(
                header: "Registration is successful!",
                  context: context,
                  text: "");
            }
            if (state.status == AuthenticationProgress.authenticated) {
              showAuthorisationSuccess(
                  header: "You logged in as ${state.user.login}",
                  context: context,
                  text: "");
            }
          },
        ),
      ],
      child: Padding(
        padding: EdgeInsets.only(
            top: 20,
            right: 15.0,
            left: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Container(
          // height: MediaQuery.of(context).size.height + 222,
          //  color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              widget.message == null
                  ? NormalFlow(
                      controller: controller,
                    )
                  : ErrorFlow(message: widget.message),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 23.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          children: [
                            const TextSpan(
                              text: "Don't have an account",
                            ),
                            const TextSpan(
                                text: "  \u2192  ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                )),
                            !state.register
                                ? WidgetSpan(
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                        //topRight: Radius.circular(20.0),
                                      ),
                                      focusColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      onTap: () {
                                        context.read<LoginBloc>().add(
                                            const AuthModeChange(
                                                authStat: AuthStat.undefined,
                                                register: true));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            right: 8.0, left: 8.0),
                                        child: Text(
                                          "Signup",
                                          style: TextStyle(
                                              height: 1,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Color.fromRGBO(
                                                  13, 13, 58, 1.0),
                                              fontWeight: FontWeight.w500),
                                          /* recognizer: TapGestureRecognizer(allowedButtonsFilter: )
                                          ..onTap = () {
                                            context.read<LoginBloc>().add(
                                                const AuthModeChange(register: true));
                                          },*/
                                        ),
                                      ),
                                    ),
                                  )
                                : const TextSpan(text: ""),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return state.status.isInProgress || (state.authStat == AuthStat.inProgress)
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.indigo.shade100),
                          ),
                          onPressed: () {
                            !state.register
                                ? context
                                    .read<LoginBloc>()
                                    .add(const LoginSubmitted())
                                : context
                                    .read<LoginBloc>()
                                    .add(const RegisterSubmitted());

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: Center(
                              child: Text(
                                state.register ? "Register" : "Continue",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(13, 13, 58, 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorFlow extends StatelessWidget {
  final String? message;

  const ErrorFlow({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          textAlign: TextAlign.justify,
          "Error occurred while trying logging in:\r\n$message",
          style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class NormalFlow extends StatelessWidget {
  const NormalFlow({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // LoginPage(),
      BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return Container(
            height: 45,
            child: TextField(
              controller: controller, //todo check
              // autofocus: true,
              onChanged: (input) {
                context.read<LoginBloc>().add(LoginEmailChanged(input));
              },
              decoration: InputDecoration(
                labelText: 'Enter email',
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black12)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.black12)),
                errorText:
                    state.email.displayError != null ? 'invalid value' : null,
              ),
            ),
          );
        },
      ),
      const SizedBox(
        height: 15,
      ),
      BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return Container(
            height: 45,
            child: TextField(
              obscureText: true,
              onChanged: (input) {
                context.read<LoginBloc>().add(LoginPasswordChanged(input));
              },
              decoration: InputDecoration(
                errorText: state.password.displayError != null
                    ? 'invalid value'
                    : null,
                labelText: 'Enter your password',
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black12)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.black12)),
              ),
            ),
          );
        },
      ),
    ]);
  }
}

Future<void> getAuthPage(
    {required BuildContext context,
    String? errorMessage,
    required AnimationController controller}) async {
  return showModalBottomSheet<void>(
      isScrollControlled: true,
      transitionAnimationController: controller,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: BlocProvider.of<LoginBloc>(context),
          child: AuthorizationPage(
            message: errorMessage,
          ),
        );
      });
}

Future<void> getAuthPageWithOutAnimation(
    {required BuildContext context,
      String? errorMessage,}) async {
  return showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: BlocProvider.of<LoginBloc>(context),
          child: AuthorizationPage(
            message: errorMessage,
          ),
        );
      });
}