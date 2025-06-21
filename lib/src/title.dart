import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(this.title, {super.key, this.color = Colors.black});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
