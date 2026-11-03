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
}) {
  if (dialogScopeBack != null) {
    dialogScopeBack!();
  }
  return Navigator.push(
    context,
    PageRouteBuilder(
      settings: routeName != null ? RouteSettings(name: routeName) : null,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      opaque: false,
      maintainState: true,
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 150),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) {
        Widget body = child;
        if (useSafeArea) {
          body = SafeArea(child: child);
        }
        return _AnimatedDialog(
          constraints: constraints,
          animation: animation,
          alignment: alignment,
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
  });
  final Animation<double> animation;
  final Widget child;
  final Alignment alignment;
  final BoxConstraints? constraints;
  @override
  State<_AnimatedDialog> createState() => _AnimatedDialogState();
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
      curve: Curves.easeInOut,
    );
    scale = Tween(
      begin: 0.8,
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
