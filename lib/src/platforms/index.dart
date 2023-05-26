export './platform_io.dart'
    if (dart.library.html) './web_io.dart'
    if (dart.library.io) './mobile_io.dart' show getFile;