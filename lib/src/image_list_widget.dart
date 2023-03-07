import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../imagewidget.dart';
import 'widgets/hero_widget.dart';
import 'widgets/image_zoom.dart';

class ImageListsWidget extends StatefulWidget {
  final Widget? header;
  final double aspectRatio;
  final List<ImageInfoData> images;
  final Color? themeColor;
  final Widget Function(String url)? videoBuilder;
  final bool isShowTitle;
  final bool shrinkWrap;

  const ImageListsWidget({
    Key? key,
    this.header,
    this.aspectRatio = 1,
    required this.images,
    this.themeColor,
    this.videoBuilder,
    this.isShowTitle = false,
    this.shrinkWrap = true,
  }) : super(key: key);

  @override
  State<ImageListsWidget> createState() => _ImageListsWidgetState();
}

class _ImageListsWidgetState extends State<ImageListsWidget> {
  void _onTapDetail(String url, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        barrierDismissible: true,
        pageBuilder: (c, a1, a2) => Material(
          color: Colors.transparent,
          child: SlidePage(
            url: url,
            images: widget.images,
            header: widget.header,
            index: index,
            themeColor: widget.themeColor,
            isShowTitle: widget.isShowTitle,
          ),
        ),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.length == 1) {
      final item = widget.images.first;
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: GestureDetector(
          child: Hero(
            tag: widget.images.first,
            child: item.type == 'video'
                ? widget.videoBuilder != null
                    ? widget.videoBuilder!(item.url)
                    : Container(
                        alignment: Alignment.center,
                        child: const Text('This is an video'),
                      )
                : ImageWidget(
                    item.url,
                    useFadeInAnimation: false,
                  ),
          ),
          onTap: () {
            _onTapDetail(item.url, 0);
          },
        ),
      );
    }

    return GridView.builder(
      primary: false,
      shrinkWrap: widget.shrinkWrap,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (BuildContext context, int index) {
        final String url = widget.images[index].url;

        return GestureDetector(
          child: Hero(
            tag: url,
            child: url == 'This is an video'
                ? widget.videoBuilder != null
                    ? widget.videoBuilder!(url)
                    : Container(
                        alignment: Alignment.center,
                        child: const Text('This is an video'),
                      )
                : ImageWidget(
                    url,
                    useFadeInAnimation: false,
                  ),
          ),
          onTap: () {
            _onTapDetail(url, index);
          },
        );
      },
      itemCount: widget.images.length,
    );
  }
}

class SlidePage extends StatefulWidget {
  final Widget? header;

  final String url;
  final List<ImageInfoData> images;
  final int index;
  final Color? themeColor;
  final Widget Function(String url)? videoBuilder;
  final bool isShowTitle;

  const SlidePage({
    Key? key,
    required this.images,
    this.header,
    required this.index,
    this.themeColor,
    this.videoBuilder,
    required this.isShowTitle,
    required this.url,
  }) : super(key: key);

  @override
  State<SlidePage> createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  final slidePagekey = GlobalKey<ExtendedImageSlidePageState>();
  late PageController _pageController;
  int pageCurrent = 0;
  bool isShowTitle = true;

  @override
  void initState() {
    pageCurrent = widget.index;
    isShowTitle = widget.isShowTitle;

    _pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isShowTitle = !isShowTitle;
          });
        },
        child: Stack(
          children: [
            ExtendedImageSlidePage(
              key: slidePagekey,
              slideAxis: SlideAxis.both,
              slideType: SlideType.onlyImage,
              child: GestureDetector(
                child: widget.url == 'This is an video'
                    ? ExtendedImageSlidePageHandler(
                        child: Material(
                          child: widget.videoBuilder != null
                              ? widget.videoBuilder!(widget.url)
                              : Container(
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
                        slideType: SlideType.wholePage,
                        slidePagekey: slidePagekey,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.images.length,
                          itemBuilder: (context, index) {
                            return ImageZoom(url: widget.images[index].url);
                          },
                          onPageChanged: (index) {
                            setState(() {
                              pageCurrent = index;
                            });
                          },
                        ),
                      ),
                onTap: () {
                  slidePagekey.currentState!.popPage();
                  Navigator.pop(context);
                },
              ),
            ),
            if (isShowTitle)
              IgnorePointer(
                ignoring: true,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, left: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              widget.images[pageCurrent].caption ?? '',
                              style: TextStyle(
                                  color: widget.themeColor ?? Colors.black),
                            ),
                          ),
                          Container(
                            color: (widget.themeColor ?? Colors.black)
                                .withOpacity(0.08),
                            margin: const EdgeInsets.only(left: 5, right: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            child: Text(
                              '${pageCurrent + 1}/${widget.images.length}',
                              style: TextStyle(
                                  color: widget.themeColor ?? Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (isShowTitle)
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 50, right: 16, left: 16),
                        child: IconButton(
                          onPressed: Navigator.of(context).pop,
                          icon: Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: widget.themeColor ?? Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    if (widget.header != null) widget.header!
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
