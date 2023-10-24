import 'package:flutter/material.dart';

/// 横屏下展开右侧Drawer
openEndDrawer({
  required BuildContext context,
  required Widget drawer,
}) {
  return Navigator.push(
    context,
    DrawerPageRoute(
      builder: (_) => drawer,
      isScrollControlled: true,
    ),
  );
}

class DrawerPageRoute<T> extends PopupRoute<T> {
  DrawerPageRoute({
    required this.builder,
    this.barrierLabel,
    this.backgroundColor,
    this.elevation,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.isScrollControlled = false,
    RouteSettings? settings,
    this.enterBottomSheetDuration = const Duration(milliseconds: 250),
    this.exitBottomSheetDuration = const Duration(milliseconds: 200),
    this.curve,
  });

  final WidgetBuilder builder;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final Color? modalBarrierColor;
  final bool isDismissible;

  // final String name;
  final Duration enterBottomSheetDuration;
  final Duration exitBottomSheetDuration;
  final Curve? curve;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.transparent;

  AnimationController? _animationController;

  @override
  Animation<double> createAnimation() {
    if (curve != null) {
      return CurvedAnimation(curve: curve!, parent: _animationController!.view);
    }
    return _animationController!.view;
  }

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    _animationController!.duration = enterBottomSheetDuration;
    _animationController!.reverseDuration = exitBottomSheetDuration;
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      child: _ModalDrawer<T>(
        route: this,
        isScrollControlled: isScrollControlled,
      ),
    );
    return bottomSheet;
  }
}

class _ModalDrawer<T> extends StatefulWidget {
  const _ModalDrawer({
    super.key,
    required this.route,
    this.isScrollControlled = false,
  });

  final DrawerPageRoute<T> route;
  final bool isScrollControlled;

  @override
  State<_ModalDrawer> createState() => _ModalDrawerState();
}

class _ModalDrawerState extends State<_ModalDrawer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (context, child) {
          final animationValue = widget.route.animation!.value;
          return CustomSingleChildLayout(
            delegate: _DrawerLayoutDelegate(
                animationValue, widget.isScrollControlled),
            child: BottomSheet(
              animationController: widget.route._animationController,
              onClosing: () {},
              builder: (_) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (widget.route.isCurrent) {
                      Navigator.pop(context);
                    }
                  },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      widget.route.builder(_),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              clipBehavior: Clip.none,
              enableDrag: false,
              shape: const Border(),
              constraints: const BoxConstraints.expand(),
            ),
          );
        });
  }
}

class _DrawerLayoutDelegate extends SingleChildLayoutDelegate {
  _DrawerLayoutDelegate(this.progress, this.isScrollControlled);

  final double progress;
  final bool isScrollControlled;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: 0.0,
      maxWidth: isScrollControlled
          ? constraints.maxWidth
          : constraints.maxWidth * 9.0 / 16.0,
      minHeight: constraints.maxHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width - childSize.width * progress, 0.0);
  }

  @override
  bool shouldRelayout(_DrawerLayoutDelegate oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
