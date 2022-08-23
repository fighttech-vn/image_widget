import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageZoom extends StatefulWidget {
  final String url;

  const ImageZoom({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<ImageZoom> createState() => _ImageZoomState();
}

typedef DoubleClickAnimationListener = void Function();

class _ImageZoomState extends State<ImageZoom> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    Animation? animation;

    Function() animationListener = () {};

    return ExtendedImage.network(
      widget.url,
      enableSlideOutPage: true,
      mode: ExtendedImageMode.gesture,
      extendedImageGestureKey: GlobalKey<ExtendedImageGestureState>(),
      initGestureConfigHandler: (ExtendedImageState state) {
        return GestureConfig(
          minScale: 0.9,
          animationMinScale: 0.7,
          maxScale: 4.0,
          animationMaxScale: 4.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: false,
          initialAlignment: InitialAlignment.center,
          reverseMousePointerScrollDirection: true,
          gestureDetailsIsChanged: (GestureDetails? details) {
            //print(details?.totalScale);
          },
        );
      },
      onDoubleTap: (ExtendedImageGestureState state) {
        ///you can use define pointerDownPosition as you can,
        ///default value is double tap pointer down postion.
        final pointerDownPosition = state.pointerDownPosition;
        final double begin = state.gestureDetails!.totalScale!;
        double end;

        animation?.removeListener(animationListener);
        animationController.stop();
        animationController.reset();

        if (begin == 1) {
          end = 3.0;
        } else {
          end = 1;
        }
        animationListener = () {
          state.handleDoubleTap(
              scale: animation!.value, doubleTapPosition: pointerDownPosition);
        };
        animation =
            animationController.drive(Tween<double>(begin: begin, end: end));

        animation!.addListener(animationListener);

        animationController.forward();
      },
    );
  }
}
