import 'package:flutter/animation.dart';

AnimationController getDefaultAnimationController(TickerProvider provider) {
  var animationController =
      AnimationController(vsync: provider, duration: Duration(seconds: 2));

  var _animation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController!, curve: Curves.fastOutSlowIn));

  return animationController;
}
//with TickerProviderStateMixin