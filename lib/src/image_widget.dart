// Copyright 2021 Fighttech.vn, Ltd. All rights reserved.

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import './platforms/platform_io.dart'
    if (dart.library.html) './platforms/web_io.dart'
    if (dart.library.io) './platforms/mobile_io.dart' show getFile;
import 'widgets/skeleton_widget.dart';

class ImageWidget extends StatelessWidget {
  static String? packageDefault = 'design_system';

  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool usePlaceHolder;
  final Color? color;
  final double? borderRadius;
  final String? package;
  final int? cacheWidth;
  final int? cacheHeight;
  final double aspectRatio;

  const ImageWidget(
    this.source, {
    Key? key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.usePlaceHolder = true,
    this.color,
    this.borderRadius,
    this.package,
    this.cacheWidth,
    this.cacheHeight,
    this.aspectRatio = 2.0,
  }) : super(key: key);

  const ImageWidget.avatar(
    this.source, {
    Key? key,
    this.fit = BoxFit.cover,
    this.width = 40,
    this.height = 40,
    this.usePlaceHolder = true,
    this.color,
    this.borderRadius = 10,
    this.package,
    this.cacheWidth,
    this.cacheHeight,
    this.aspectRatio = 2.0,
  }) : super(key: key);

  Widget copyWith({Color? color, double? width, double? height}) {
    return ImageWidget(
      source,
      key: key,
      fit: fit,
      width: width ?? width,
      height: height ?? height,
      usePlaceHolder: usePlaceHolder,
      color: color ?? this.color,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (source.isEmpty) {
      body = const Placeholder();
    } else if (source.contains('.svg')) {
      body = source.contains('http')
          ? SvgPicture.network(
              source,
              fit: fit,
              color: color,
              width: width,
              height: height,
            )
          : SvgPicture.asset(
              source,
              fit: fit,
              color: color,
              width: width,
              height: height,
              package: package ?? packageDefault,
            );
    } else if (source.contains('http')) {
      body = ExtendedImage.network(
        source,
        cache: true,
        fit: fit,
        loadStateChanged: loadStateChanged,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    } else if (source.startsWith('/') ||
        source.startsWith('file://') ||
        source.substring(1).startsWith(':\\')) {
      body = ExtendedImage.file(
        getFile(source),
        fit: fit,
        loadStateChanged: loadStateChanged,
      );
    } else if (source.contains('.json')) {
      return Lottie.asset(
        source,
        package: package ?? packageDefault,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      body = Image.asset(
        source,
        fit: fit,
        width: width,
        height: height,
        package: package ?? packageDefault,
      );
    }
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: body,
      );
    }

    return body;
  }

  Widget? loadStateChanged(ExtendedImageState state) {
    Widget widget;
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        if (width != null) {
          return SizedBox(
              width: width, height: height, child: const Skeleton());
        }
        return LayoutBuilder(builder: (context, contraint) {
          return AspectRatio(
            aspectRatio: aspectRatio,
            child: const Skeleton(),
          );
        });

      case LoadState.completed:
        widget = ExtendedRawImage(
          image: state.extendedImageInfo?.image,
          width: width,
          height: height,
          fit: fit,
        );
        break;
      case LoadState.failed:
        widget = Container(
          width: width,
          height: height,
          color: Colors.grey,
        );
        break;
    }
    return widget;
  }
}
