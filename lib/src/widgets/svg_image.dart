import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  final String string;
  final double? width;
  final double? height;

  const SvgImage(
    this.string, {
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      string,
      width: width,
      height: height,
    );
  }
}
