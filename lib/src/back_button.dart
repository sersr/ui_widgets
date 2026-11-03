import 'package:material_ui/material_ui.dart';

import 'button.dart';

/// 返回按钮
class BaseBackButton extends StatelessWidget {
  const BaseBackButton({super.key, this.onBack})
      : color = Colors.white,
        overlayColor = const Color.fromARGB(67, 236, 236, 236);
  const BaseBackButton.black({super.key, this.onBack})
      : color = Colors.black,
        overlayColor = const Color.fromARGB(161, 203, 203, 203);

  final VoidCallback? onBack;
  final Color color;
  final Color overlayColor;

  @override
  Widget build(BuildContext context) {
    if (!Navigator.canPop(context)) return const SizedBox();

    return Container(
      height: 56,
      width: 56,
      margin: const EdgeInsets.only(left: 2),
      child: OverflowBox(
        maxHeight: 60,
        maxWidth: 60,
        minHeight: 60,
        minWidth: 60,
        child: InkButton(
          onPressed: onBack ?? () => Navigator.pop(context),
          backgroundColor: Colors.transparent,
          overlayColor: overlayColor,
          isStadium: true,
          child: Icon(Icons.arrow_back_ios, color: color, size: 20),
        ),
      ),
    );
  }
}

/// 按钮范围比较小

class BaseBackClosedButton extends StatelessWidget {
  const BaseBackClosedButton({super.key})
      : color = Colors.white,
        overlayColor = const Color.fromARGB(67, 236, 236, 236);
  const BaseBackClosedButton.black({super.key})
      : color = Colors.black,
        overlayColor = const Color.fromARGB(161, 203, 203, 203);

  final Color color;
  final Color overlayColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      height: 40,
      width: 40,
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: InkButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.transparent,
          overlayColor: overlayColor,
          isStadium: true,
          child: Icon(Icons.arrow_back_ios, color: color, size: 20),
        ),
      ),
    );
  }
}

class BgBackButton extends StatelessWidget {
  const BgBackButton({super.key, this.left})
      : color = Colors.black,
        overlayColor = const Color.fromARGB(161, 203, 203, 203);

  final Color color;
  final Color overlayColor;
  final double? left;

  @override
  Widget build(BuildContext context) {
    final canBack = Navigator.canPop(context);
    if (!canBack) return const SizedBox();

    return Container(
      margin: EdgeInsets.only(left: left ?? 14),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back_ios_new, size: 30, color: color),
      ),
    );
  }
}
