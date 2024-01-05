import 'package:flutter/material.dart';

class SplashLoad extends StatelessWidget {
  const SplashLoad({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width - 100,
      child: const Center(
          child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 1.5),
          )
      ),
    );
  }
}
