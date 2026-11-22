import 'package:material_ui/material_ui.dart';

import 'loading_dialog.dart';

/// 弹窗动画
///
/// NOTE: [PageRouteBuilder], 如果不是 [PageRoute]，[Get].toNamed 会出现问题
Future<T?> showCenterDialog<T>(
  BuildContext context,
  Widget child, {
  Alignment alignment = Alignment.center,
  bool useSafeArea = true,
  BoxConstraints? constraints,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? routeName,
  Curve? curve,
  Curve? reverseCurve,
}) {
  if (dialogScopeBack != null) {
    dialogScopeBack!();
  }
  return Navigator.push(
    context,
    _DialogPageRouteBuilder(
      settings: routeName != null ? RouteSettings(name: routeName) : null,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      opaque: false,
      maintainState: true,
      fullscreenDialog: false,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        Widget body = child;
        if (useSafeArea) {
          body = SafeArea(child: child);
        }
        return _AnimatedDialog(
          constraints: constraints,
          animation: animation,
          alignment: alignment,
          curve: curve,
          reverseCurve: reverseCurve,
          child: body,
        );
      },
    ),
  );
}

class _AnimatedDialog extends StatefulWidget {
  const _AnimatedDialog({
    required this.animation,
    required this.child,
    required this.alignment,
    this.constraints,
    this.curve,
    this.reverseCurve,
  });
  final Animation<double> animation;
  final Widget child;
  final Alignment alignment;
  final BoxConstraints? constraints;
  final Curve? curve;
  final Curve? reverseCurve;
  @override
  State<_AnimatedDialog> createState() => _AnimatedDialogState();
}

class _DialogPageRouteBuilder<T> extends PageRouteBuilder<T> {
  new({
    super.settings,
    super.requestFocus,
    required super.pageBuilder,
    super.transitionsBuilder,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.opaque,
    super.barrierDismissible,
    super.barrierColor,
    super.barrierLabel,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
  });

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return false;
  }
}

class _AnimatedDialogState extends State<_AnimatedDialog> {
  late CurvedAnimation curvedAnimation;

  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() {
    curvedAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: widget.curve ?? Curves.easeInOut,
      reverseCurve: widget.reverseCurve,
    );
    scale = Tween(
      begin: 0.6,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(widget.animation);
  }

  @override
  void didUpdateWidget(covariant _AnimatedDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      curvedAnimation.dispose();
      update();
    }
  }

  @override
  void dispose() {
    curvedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = ScaleTransition(
      scale: scale,
      child: FadeTransition(opacity: curvedAnimation, child: widget.child),
    );
    return Align(
      alignment: widget.alignment,
      child: Container(
        constraints: widget.constraints ?? const BoxConstraints(maxWidth: 640),
        child: body,
      ),
    );
  }
}
