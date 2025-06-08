import 'dart:async';

import 'package:flutter/material.dart';

import 'pop_message.dart';

class AppExitScope extends StatefulWidget {
  const AppExitScope({super.key, required this.child});
  final Widget child;

  @override
  State<AppExitScope> createState() => _AppExitScopeState();
}

class _AppExitScopeState extends State<AppExitScope> {
  final exit = ValueNotifier(false);

  void onPop(bool didPop) {
    if (Navigator.canPop(context)) return;

    if (didPop) return;

    exit.value = true;
    showMsgB('Press again to exit!');
    Timer(const Duration(milliseconds: 1000), () {
      exit.value = false;
    });
  }

  void onPopResult(bool didPop, result) {
    if (Navigator.canPop(context)) return;

    if (didPop) return;

    exit.value = true;
    showMsgB('Press again to exit!');
    Timer(const Duration(milliseconds: 1000), () {
      exit.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: exit,
      builder: (context, _) {
        final canPop = exit.value;
        return PopScope(
          canPop: canPop,
          onPopInvokedWithResult: onPopResult,
          child: widget.child,
        );
      },
    );
  }
}
