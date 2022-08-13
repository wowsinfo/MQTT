import 'dart:io';

import 'package:flutter/foundation.dart';

class App {
  static const isWeb = kIsWeb;
  static final isMobile = !isWeb && (isAndroid || isIOS);
  static final isDesktop = !isMobile;
  static final isWindows = Platform.isWindows;
  static final isAndroid = Platform.isAndroid;
  static final isIOS = Platform.isIOS;
}
