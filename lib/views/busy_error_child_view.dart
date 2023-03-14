import 'package:client_app/theme.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BusyErrorChildView extends StatelessWidget {
  const BusyErrorChildView(
      {super.key, required this.viewState, required this.builder});

  final ViewStates viewState;
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: Builder(
          key: ValueKey(viewState),
          builder: (context) {
            if (viewState == ViewStates.busy) {
              return LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxHeight.isFinite) {
                  return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                    color: primaryColor,
                    size: 50,
                  ));
                } else {
                  return SizedBox(
                    height: 400,
                    child: Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                      color: primaryColor,
                      size: 50,
                    )),
                  );
                }
              });
            } else if (viewState == ViewStates.error) {
              return LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxHeight.isFinite) {
                  return const Center(child: Text("Error"));
                } else {
                  return const SizedBox(
                    height: 400,
                    child: Center(child: Text("Error")),
                  );
                }
              });
            } else {
              return builder();
            }
          }),
    );
  }
}
