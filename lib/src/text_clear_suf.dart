import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextClearSufWidget extends StatelessWidget {
  const TextClearSufWidget({super.key, required this.controller, this.padding});
  final TextEditingController controller;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.text.isEmpty) {
          return const SizedBox();
        }
        return child!;
      },
      child: GestureDetector(
        onTap: () {
          controller.text = '';
        },
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w),
          child: Icon(Icons.close_rounded, size: 24.r),
        ),
      ),
    );
  }
}
