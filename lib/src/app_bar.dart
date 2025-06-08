import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({
    super.key,
    this.listenable,
    this.color = Colors.white,
    this.leading,
    this.center,
    this.trailing,
    this.centerMiddle = true,
    this.height,
    this.removeTop = true,
    this.middleSpacing = NavigationToolbar.kMiddleSpacing,
  });
  final ValueNotifier<double>? listenable;
  final Color color;
  final Widget? leading;
  final Widget? center;
  final Widget? trailing;
  final bool centerMiddle;
  final double? height;
  final bool removeTop;
  final double middleSpacing;

  static double get defaultHeight => ScreenUtil().statusBarHeight + 56.h;

  @override
  Widget build(BuildContext context) {
    Widget bar = NavigationToolbar(
      leading: leading,
      middle: center,
      centerMiddle: centerMiddle,
      trailing: trailing,
      middleSpacing: middleSpacing,
    );

    final height = this.height ?? 56.h;
    bar = SizedBox(height: height, child: bar);

    if (removeTop) {
      bar = SafeArea(bottom: false, child: bar);
    }
    if (listenable != null) {
      return RepaintBoundary(
        child: AnimatedBuilder(
          animation: listenable!,
          builder: (context, _) {
            final value = listenable!.value.clamp(0.0, 1.0);
            final realColor = color.withValues(alpha: value);

            return Material(color: realColor, child: bar);
          },
        ),
      );
    }

    return Material(color: color, child: bar);
  }
}
