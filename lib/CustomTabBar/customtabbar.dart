import 'package:calenderselection/HelperVariable.dart';
import 'package:flutter/material.dart';

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder listCountBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;
  final bool isScroll;
  final Color indicatorColor;


  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.listCountBuilder,
    required this.pageBuilder,
    required this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
    required this.isScroll,
    this.indicatorColor = colorCode.black,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;


  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation!.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 :
        _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            if(mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation!.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: colorCode.white,
          child: TabBar(
            isScrollable: false,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            labelStyle: TextStyle(fontSize: 13,),
            controller: controller,
            labelColor: colorCode.black,
            unselectedLabelColor: colorCode.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: widget.indicatorColor,
                  width: 3,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
                  (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.tabBuilder(context, index),
                      widget.listCountBuilder(context, index) == null
                          ? SizedBox()
                          : widget.listCountBuilder(context, index)
                    ],
                  ),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            physics: widget.isScroll != null && widget.isScroll == false
                ? const NeverScrollableScrollPhysics()
                : null,
            children: List.generate(
              widget.itemCount,
                  (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }
}