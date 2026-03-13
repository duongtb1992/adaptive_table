import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SvgAssetImage extends StatelessWidget {
  const SvgAssetImage(this.image,
      {super.key, this.fit = BoxFit.fill, this.width, this.height, this.color});

  final String image;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      fit: fit,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}

class SvgImageProvider extends ImageProvider<SvgImageProvider> {
  final String assetName;
  final double scale;
  final Size? containerSize;
  final Color? color;

  const SvgImageProvider(this.assetName,
      {this.scale = 1.0, this.containerSize, this.color});

  @override
  Future<SvgImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<SvgImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
      SvgImageProvider key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(_loadImage(key));
  }

  Future<ImageInfo> _loadImage(SvgImageProvider key) async {
    try {
      // print('Loading SVG: ${key.assetName}');
      final bytes = await rootBundle.load(key.assetName);
      final svg = await vg.loadPicture(
          SvgBytesLoader(bytes.buffer.asUint8List()), null);

      final size = svg.size;
      final deviceScale = key.scale;

      double width, height;
      if (containerSize != null) {
        final aspectRatio = size.width / size.height;
        if (containerSize!.width / containerSize!.height > aspectRatio) {
          height = containerSize!.height;
          width = height * aspectRatio;
        } else {
          width = containerSize!.width;
          height = width / aspectRatio;
        }
      } else {
        width = size.width;
        height = size.height;
      }

      final scaledWidth = (width * deviceScale).round();
      final scaledHeight = (height * deviceScale).round();

      print('Rendering at: $scaledWidth x $scaledHeight (old: $width $height)');

      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, scaledWidth.toDouble(), scaledHeight.toDouble()));

      // Áp dụng scale
      canvas.scale(scaledWidth / size.width, scaledHeight / size.height);

      // Áp dụng màu nếu có
      if (key.color != null) {
        final paint = Paint()
          ..colorFilter = ColorFilter.mode(key.color!, BlendMode.srcIn);
        canvas.drawPicture(svg.picture);
        canvas.saveLayer(null, paint);
      }

      canvas.drawPicture(svg.picture);
      final image =
          await recorder.endRecording().toImage(scaledWidth, scaledHeight);

      return ImageInfo(image: image, scale: deviceScale);
    } catch (e, stackTrace) {
      print('Error loading SVG: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is SvgImageProvider &&
        other.assetName == assetName &&
        other.scale == scale &&
        other.containerSize == containerSize &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(assetName, scale, containerSize, color);
}
