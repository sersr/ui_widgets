import 'package:material_ui/material_ui.dart';
import 'package:flutter/widgets.dart';

abstract final class GlobalContext {
  static BuildContext get context => globalObserver.navigator!.context;
  static BuildContext get overlayContext =>
      globalObserver.navigator!.overlay!.context;
  static final NavigatorObserver globalObserver = RouteObserver();
}

abstract final class Nav {
  static Locale? get locale {
    return Localizations.maybeLocaleOf(GlobalContext.context);
  }

  static void back([dynamic result]) {
    GlobalContext.globalObserver.navigator?.pop(result);
  }

  static double get screenWidth {
    return MediaQuery.sizeOf(GlobalContext.context).width;
  }

  static double get screenHeight {
    return MediaQuery.sizeOf(GlobalContext.context).height;
  }

  static double get statusBarHeight {
    return MediaQuery.paddingOf(GlobalContext.context).top;
  }
}
