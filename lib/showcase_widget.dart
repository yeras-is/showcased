import 'package:flutter/material.dart';

class ShowCaseWidget extends StatefulWidget {
  final Builder builder;
  final VoidCallback? onFinish;
  final Function(int?, GlobalKey)? onStart;
  final Function(int?, GlobalKey)? onComplete;
  final bool autoPlay;
  final Duration autoPlayDelay;
  final bool autoPlayLockEnable;

  const ShowCaseWidget({
    required this.builder,
    this.onFinish,
    this.onStart,
    this.onComplete,
    this.autoPlay = false,
    this.autoPlayDelay = const Duration(milliseconds: 2000),
    this.autoPlayLockEnable = false,
  });

  static activeTargetWidget(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_Inheritedshowcased>()!.activeWidgetIds;
  }

  static ShowCaseWidgetState? of(BuildContext context) {
    ShowCaseWidgetState? state = context.findAncestorStateOfType<ShowCaseWidgetState>();
    if (state != null) {
      return context.findAncestorStateOfType<ShowCaseWidgetState>();
    } else {
      throw Exception('Please provide showcased context');
    }
  }

  @override
  ShowCaseWidgetState createState() => ShowCaseWidgetState();
}

class ShowCaseWidgetState extends State<ShowCaseWidget> {
  List<GlobalKey>? ids;
  int? activeWidgetId;
  late bool autoPlay;
  late Duration autoPlayDelay;
  late bool autoPlayLockEnable;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.autoPlayDelay = widget.autoPlayDelay;
    this.autoPlay = widget.autoPlay;
    this.autoPlayLockEnable = widget.autoPlayLockEnable;
  }

  void startShowCase(List<GlobalKey> widgetIds) {
    setState(() {
      this.ids = widgetIds;
      activeWidgetId = 0;
      _onStart();
    });
  }

  void completed(GlobalKey? id) {
    if (ids != null && ids![activeWidgetId!] == id) {
      setState(() {
        _onComplete();
        if (activeWidgetId != null) activeWidgetId = activeWidgetId! + 1;
        _onStart();

        if (activeWidgetId! >= ids!.length) {
          _cleanupAfterSteps();
          if (widget.onFinish != null) {
            widget.onFinish!();
          }
        }
      });
    }
  }

  void dismiss() {
    setState(() {
      _cleanupAfterSteps();
    });
  }

  void _onStart() {
    if (activeWidgetId! < ids!.length) {
      widget.onStart?.call(activeWidgetId, ids![activeWidgetId!]);
    }
  }

  void _onComplete() {
    widget.onComplete?.call(activeWidgetId, ids![activeWidgetId!]);
  }

  void _cleanupAfterSteps() {
    ids = null;
    activeWidgetId = null;
  }

  @override
  Widget build(BuildContext context) {
    return _Inheritedshowcased(
      child: widget.builder,
      activeWidgetIds: ids?.elementAt(activeWidgetId!),
    );
  }
}

class _Inheritedshowcased extends InheritedWidget {
  final GlobalKey? activeWidgetIds;

  _Inheritedshowcased({
    required this.activeWidgetIds,
    required child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_Inheritedshowcased oldWidget) => oldWidget.activeWidgetIds != activeWidgetIds;
}
