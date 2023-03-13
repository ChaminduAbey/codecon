import 'package:flutter/material.dart';

class ConstrainedButton extends StatelessWidget {
  const ConstrainedButton({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          alignment: Alignment.center,
          child: SizedBox(width: double.infinity, child: child)),
    );
  }
}