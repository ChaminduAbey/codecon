import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class StaggerAnimationChild extends StatelessWidget {
  const StaggerAnimationChild(
      {super.key,
      required this.child,
      required this.index,
      this.direction = Axis.vertical});

  final Widget child;
  final int index;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
            verticalOffset: direction == Axis.vertical ? 50.0 : 0.0,
            horizontalOffset: direction == Axis.horizontal ? 50.0 : 0.0,
            child: FadeInAnimation(
              child: child,
            )));
  }
}
