import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_app/models/cdn_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageWidget extends StatefulWidget {
  final String imageUrl;
  final String blurhash;
  final BoxFit fit;
  final Widget Function(BuildContext, ImageProvider)? imageBuilder;
  final double? height;
  final double? width;
  final FilterQuality filterQuality;
  const ImageWidget({
    Key? key,
    required this.imageUrl,
    required this.blurhash,
    this.fit = BoxFit.cover,
    this.imageBuilder,
    this.height,
    this.width,
    this.filterQuality = FilterQuality.medium,
  }) : super(key: key);

  ImageWidget.fromCdn(
    CdnImage cdnImage, {
    Key? key,
    this.fit = BoxFit.cover,
    this.imageBuilder,
    this.height,
    this.width,
    this.filterQuality = FilterQuality.medium,
  })  : this.imageUrl = cdnImage.url,
        this.blurhash = cdnImage.blurhash,
        super(key: key);

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late Uint8List bytes;
  @override
  void initState() {
    final BlurHash blurHash = BlurHash.decode(widget.blurhash);
    final img.Image _image = blurHash.toImage(35, 20);
    bytes = Uint8List.fromList(img.encodeJpg(_image));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: widget.height,
      width: widget.width,
      imageUrl: widget.imageUrl,
      imageBuilder: widget.imageBuilder,
      fit: widget.fit,
      filterQuality: widget.filterQuality,
      placeholder: (context, url) => LayoutBuilder(
        builder: (context, constraints) {
          final widgetHeight = constraints.maxHeight;
          return SizedBox(
            height: widgetHeight,
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}