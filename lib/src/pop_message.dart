import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'pop_dialog.dart';

String? _lastMsg;
Timer? _timer;

abstract final class GlobalContext {
  static BuildContext? _context;
  static BuildContext get context => _context!;
  static void init(BuildContext context) {
    _context = context;
  }
}

void showMsgB(String text) {
  if (text.isEmpty) return;
  if (text == _lastMsg) return;

  _lastMsg = text;
  _timer?.cancel();
  _timer = Timer(const Duration(seconds: 1, milliseconds: 500), () {
    _lastMsg = null;
  });

  showMsg(text);
}

void showMsg(String info, {Alignment? alignment, String? icon}) {
  final child = Text(
    info,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
    textAlign: TextAlign.center,
  );

  Widget body = Material(
    borderRadius: BorderRadius.circular(16.r),
    color: Colors.black.withValues(alpha: 0.7),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
      child: child,
    ),
  );
  body = Container(
    padding: EdgeInsets.symmetric(horizontal: 30.w),
    child: body,
  );

  popDialog(GlobalContext._context!, body, alignment: Alignment.center);
}
