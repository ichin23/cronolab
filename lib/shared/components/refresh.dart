import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Refresh extends StatefulWidget {
  final Widget child;

  const Refresh({Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  final Future<void> Function() onRefresh;

  @override
  _RefreshState createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> with SingleTickerProviderStateMixin {
  static const _indicatorSize = 150.0;
  final _scaleTween = Tween(begin: 1, end: 0.7);

  /// Whether to render check mark instead of spinner
  bool _renderCompleteState = false;

  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomRefreshIndicator(
      offsetToArmed: _indicatorSize,
      onRefresh: widget.onRefresh,
      completeStateDuration: const Duration(milliseconds: 300),
      onStateChanged: (change) {
        /// set [_renderCompleteState] to true when controller.state become completed
        if (change.didChange(to: IndicatorState.complete)) {
          setState(() {
            _renderCompleteState = true;
          });

          /// set [_renderCompleteState] to false when controller.state become idle
        } else if (change.didChange(to: IndicatorState.idle)) {
          setState(() {
            _renderCompleteState = false;
          });
        }
        print(change);
      },
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        controller.addListener(() {
          print(controller.value);
        });
        print(controller.isDragging);
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                if (controller.scrollingDirection == ScrollDirection.reverse &&
                    prevScrollDirection == ScrollDirection.forward) {
                  //controller.stopDrag();
                }

                prevScrollDirection = controller.scrollingDirection;

                final containerHeight = controller.value * _indicatorSize;

                return Container(
                  alignment: Alignment.center,
                  height: containerHeight,
                  child: !controller.isIdle
                      ? OverflowBox(
                          maxHeight: 40,
                          minHeight: 40,
                          maxWidth: 40,
                          minWidth: 40,
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _renderCompleteState
                                  ? Colors.greenAccent
                                  : Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: _renderCompleteState
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.white),
                                      value: controller.isDragging ||
                                              controller.isArmed
                                          ? controller.value.clamp(0.0, 1.0)
                                          : null,
                                    ),
                                  ),
                          ),
                        )
                      : null,
                );
              },
            ),
            Center(
              child: AnimatedBuilder(
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0.0, controller.value * _indicatorSize),
                    child: child,
                  );
                },
                animation: controller,
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
