# imagewidget
Fighttech Flutter Image Widget
- https://pub.dev/packages/imagewidget
- https://fighttech-vn.github.io/image-widget

# setup
Not use package `design_system`
main.dart
```
  ImageWidget.packageDefault = null;
```

## Easy render image widget
```
ImageWidget(
    pathIcon,
    color: Colors.white,
    height: size,
    width: size,
  ),
```

## Support image string 
```
SvgImage('string')
```
