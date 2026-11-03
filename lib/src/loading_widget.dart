import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';

import 'loading.dart';

class LoadingIndicatorState {
  final state = ValueNotifier(false);

  late int _count = 0;

  Future<T> load<T>(Future<T> Function() task, {bool show = true}) async {
    // ignore: invalid_use_of_protected_member
    if (state.hasListeners &&
        SchedulerBinding.instance.schedulerPhase ==
            SchedulerPhase.persistentCallbacks) {
      await SchedulerBinding.instance.endOfFrame;
    }

    _count += 1;
    state.value = show;
    final future = task();

    future.whenComplete(() {
      _count -= 1;
      if (_count <= 0) {
        state.value = false;
      }
    });

    return future;
  }
}

/// 包含整个页面
class LoadingPageWidget extends StatefulWidget {
  const LoadingPageWidget({
    super.key,
    required this.loading,
    required this.child,
  });
  final LoadingIndicatorState loading;
  final Widget child;

  @override
  State<LoadingPageWidget> createState() => _LoadingPageWidgetState();
}

class _LoadingPageWidgetState extends State<LoadingPageWidget> {
  var _show = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _show = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadingWidget = Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: widget.loading.state,
        builder: (context, _) {
          if (widget.loading.state.value && _show) {
            return const Loading();
          }
          return const SizedBox();
        },
      ),
    );

    return Stack(
      children: [widget.child, Positioned.fill(child: loadingWidget)],
    );
  }
}
