import 'package:flutter/material.dart';

import 'button.dart';
import 'image.dart';
import 'loading_dialog.dart';

/// 弹窗动画
///
/// NOTE: [PageRouteBuilder], 如果不是 [PageRoute]，[Get].toNamed 会出现问题
Future<T?> showCenterDialog<T>(
  BuildContext context,
  Widget child, {
  Alignment alignment = Alignment.center,
  bool useSafeArea = true,
  bool barrierDismissible = true,
  Color? barrierColor,
}) {
  if (dialogScopeBack case var back?) {
    back();
  }
  return Navigator.push(
    context,
    PageRouteBuilder(
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
  });
  final Animation<double> animation;
  final Widget child;
  final Alignment alignment;
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
    return Align(alignment: widget.alignment, child: body);
  }
}

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    this.img,
    this.title,
    this.message,
    this.leftLabel,
    this.rightLabel,
    this.leftVoidCallback,
    this.rightVoidCallback,
    this.center,
    this.showCloseBtn = true,
  });

  final String? img;
  final String? title;
  final String? message;
  final String? leftLabel;
  final String? rightLabel;
  final VoidCallback? leftVoidCallback;
  final VoidCallback? rightVoidCallback;
  final Widget? center;
  final bool showCloseBtn;

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[];

    if (img case String img) {
      list.add(AImage(img, fit: BoxFit.fitWidth));
    }
    if (title case String title) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    if (message case String message) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(top: 14, left: 30, right: 30),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (center case Widget child) {
      list.add(child);
    }

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: list),
    );

    final buttons = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          InkButton(
            onPressed: () {
              rightVoidCallback?.call();
            },
            padding: const EdgeInsets.symmetric(vertical: 14),
            borderRadius: BorderRadius.circular(8),
            backgroundColor: const Color(0xFF3573FC),
            overlayColor: const Color.fromARGB(44, 255, 255, 255),
            child: Center(
              child: Text(
                rightLabel ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkButton(
            onPressed: () {
              leftVoidCallback?.call();
            },
            padding: const EdgeInsets.symmetric(vertical: 14),
            borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.transparent,
            overlayColor: const Color.fromARGB(44, 211, 211, 211),
            side: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
            child: Center(
              child: Text(
                leftLabel ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                content,
                const SizedBox(height: 24),
                buttons,
                const SizedBox(height: 24),
              ],
            ),
            // Positioned(
            //   right: 20,
            //   top: 20,
            //   child: SizedBox(
            //     width: 24,
            //     height: 24,
            //     child: OverflowBox(
            //       maxHeight: 32,
            //       maxWidth: 32,
            //       minHeight: 32,
            //       minWidth: 32,
            //       child: InkButton.text(
            //         onPressed: () {
            //           Get.back();
            //         },
            //         padding: EdgeInsets.zero,
            //         child: getImage(
            //           'btn_close',
            //           width: 24,
            //           fit: BoxFit.fitWidth,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
