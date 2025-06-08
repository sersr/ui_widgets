import 'package:flutter/widgets.dart';

/// 点击其他地方调用[FocusScope.unfocus]，
/// 使用场景：隐藏虚拟键盘
class UnFocus extends StatelessWidget {
  const UnFocus({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (_) {
        FocusScope.of(
          context,
        ).unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
      },
      child: child,
    );
  }
}

/// `FocusScope.of(context).requestFocus(empty);` empty 做为焦点，
/// 避免弹窗关闭再次弹出虚拟键盘
class UnFocusS extends StatefulWidget {
  const UnFocusS({super.key, this.child});
  final Widget? child;

  @override
  State<UnFocusS> createState() => _UnFocusSState();
}

class _UnFocusSState extends State<UnFocusS> {
  final empty = FocusNode();
  @override
  void dispose() {
    empty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (_) {
        FocusScope.of(context).requestFocus(empty);
      },
      child: widget.child,
    );
  }
}
