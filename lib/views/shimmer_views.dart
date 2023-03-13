import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// base widget that adds the color and durations to shimmer constructor
class ShimmerBase extends StatelessWidget {
  const ShimmerBase({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(0.08),
      highlightColor: Colors.black.withOpacity(0.15),
      period: const Duration(seconds: 2),
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox(
      {Key? key,
      this.width = double.infinity,
      this.height = 30,
      this.borderRadius,
      this.radius})
      : assert(borderRadius == null || radius == null),
        super(key: key);

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
        child: Container(
      decoration: BoxDecoration(
          borderRadius: _getBorderRadius(),
          color: kIsWeb ? Colors.grey.shade200 : Colors.black),
      height: height,
      width: width,
    ));
  }

  BorderRadius? _getBorderRadius() {
    if (radius != null) return BorderRadius.circular(radius!);
    if (borderRadius != null) return borderRadius!;
  }
}
