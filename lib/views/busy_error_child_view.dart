import 'package:client_app/view_state_mixin.dart';
import 'package:flutter/material.dart';

class BusyErrorChildView extends StatelessWidget {
  const BusyErrorChildView(
      {super.key, required this.viewState, required this.builder});

  final ViewStates viewState;
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    if (viewState == ViewStates.busy) {
      return const Center(child: CircularProgressIndicator());
    } else if (viewState == ViewStates.error) {
      return const Center(child: Text("Error"));
    } else {
      return builder();
    }
  }
}
