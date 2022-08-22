import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../imagewidget.dart';
import 'widgets/hero_widget.dart';
import 'widgets/image_zoom.dart';

class ImageListsWidget extends StatefulWidget {
  final List<String> images;

  const ImageListsWidget({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<ImageListsWidget> createState() => _ImageListsWidgetState();
}

class _ImageListsWidgetState extends State<ImageListsWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      primary: false,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (BuildContext context, int index) {
        final String url = widget.images[index];
        return GestureDetector(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Hero(
              tag: url,
              child: url == 'This is an video'
                  ? Container(
                      alignment: Alignment.center,
                      child: const Text('This is an video'),
                    )
                  : ImageWidget(
                      url,
                    ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.transparent,
                barrierDismissible: true,
                pageBuilder: (c, a1, a2) => SlidePage(
                  url: url,
                  listUrl: widget.images,
                ),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 200),
              ),
            );
          },
        );
      },
      itemCount: widget.images.length,
    );
  }
}

class SlidePage extends StatefulWidget {
  const SlidePage({
    Key? key,
    required this.url,
    required this.listUrl,
  }) : super(key: key);

  final String url;
  final List<String> listUrl;

  @override
  State<SlidePage> createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  final slidePagekey = GlobalKey<ExtendedImageSlidePageState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ExtendedImageSlidePage(
        key: slidePagekey,
        slideAxis: SlideAxis.both,
        slideType: SlideType.onlyImage,
        child: GestureDetector(
          child: widget.url == 'This is an video'
              ? ExtendedImageSlidePageHandler(
                  child: Material(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.yellow,
                      child: const Text('This is an video'),
                    ),
                  ),

                  ///make hero better when slide out
                  heroBuilderForSlidingPage: (Widget result) {
                    return Hero(
                      tag: widget.url,
                      child: result,
                      flightShuttleBuilder: (BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext) {
                        final Hero hero =
                            (flightDirection == HeroFlightDirection.pop
                                ? fromHeroContext.widget
                                : toHeroContext.widget) as Hero;

                        return hero.child;
                      },
                    );
                  },
                )
              : HeroWidget(
                  tag: widget.url,
                  slideType: SlideType.onlyImage,
                  slidePagekey: slidePagekey,
                  child: PageView.builder(
                      controller: PageController(
                          initialPage: widget.listUrl
                              .indexWhere((element) => element == widget.url)),
                      itemCount: widget.listUrl.length,
                      itemBuilder: (context, index) {
                        return ImageZoom(url: widget.listUrl[index]);
                      }),
                ),
          onTap: () {
            slidePagekey.currentState!.popPage();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
