import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'loading.dart';
import 'navigator_observer.dart';

Future<void> showLoadingDialog({
  bool barrierDismissible = false,
  Alignment? alignment,
  Color barrierColor = Colors.transparent,
  Duration duration = Duration.zero,
  String? routeName,
}) {
  return showDialog(
    context: GlobalContext.context,
    builder: (context) =>
        LoadingDialog(alignment: alignment, duration: duration),
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    routeSettings: routeName == null ? null : RouteSettings(name: routeName),
  );
}

Future<T> showLoadingDialogScope<T>(
  Future<T> Function(VoidCallback back) task, {
  bool barrierDismissible = false,
  Alignment? alignment,
  Color barrierColor = Colors.transparent,
  Duration duration = Duration.zero,
}) {
  return showDialogScope(
    task,
    dialog: () {
      return showLoadingDialog(
        barrierDismissible: barrierDismissible,
        alignment: alignment,
        duration: duration,
        barrierColor: barrierColor,
      );
    },
  );
}

/// 支持[SynchronousFuture]
Future<T> showDialogScope<T>(
  Future<T> Function(VoidCallback back) task, {
  bool barrierDismissible = false,
  Alignment? alignment,
  Color barrierColor = Colors.transparent,
  required Future<void> Function() dialog,
}) {
  var backed = false;
  var isInit = false;

  void back() {
    if (backed) return;
    backed = true;
    if (isInit) Nav.back();
  }

  // 无操作
  void innerBack() {}

  if (dialogScopeBack case var fn?) {
    fn();
  }

  return runZoned(() {
    final result = task(back);
    result.whenComplete(back);
    if (backed) return result;
    isInit = true;

    runZoned(
      () => dialog().whenComplete(() => backed = true),
      zoneValues: {_dialogScopeZone: innerBack},
    );

    return result;
  }, zoneValues: {_dialogScopeZone: back});
}

VoidCallback? get dialogScopeBack {
  if (Zone.current[_dialogScopeZone] case VoidCallback fn) {
    return fn;
  }
  return null;
}

final _dialogScopeZone = Object();

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key, this.alignment, required this.duration});

  final Alignment? alignment;

  /// 在[duration]时间范围内阻止返回事件
  final Duration duration;

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  bool canPop = true;

  @override
  void initState() {
    super.initState();
    updatePopState();
  }

  void updatePopState() {
    if (widget.duration > Duration.zero) {
      canPop = false;
      Timer(widget.duration, () {
        if (mounted) {
          canPop = true;
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Loading(alignment: widget.alignment),
    );
  }
}
