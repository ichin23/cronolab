import 'package:flutter/material.dart';

class CardAnimatedOnHover extends StatefulWidget {
  const CardAnimatedOnHover({
    super.key,
    this.width = 350,
    this.height = 200,
    this.color = Colors.purple,
    this.stroke = 4,
    this.radius = 12,
    this.child,
  });
  final double width, height, stroke, radius;
  final Color color;
  final Widget? child;

  @override
  State<CardAnimatedOnHover> createState() => _CardAnimatedOnHoverState();
}

class _CardAnimatedOnHoverState extends State<CardAnimatedOnHover>
    with SingleTickerProviderStateMixin {
  late Animation _anim;
  late AnimationController _animCont;
  int _anchorPoint = 0;

  @override
  void initState() {
    super.initState();

    _animCont = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _anim = Tween<double>(begin: 0, end: 1).animate(_animCont)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: MouseRegion(
            onEnter: (ev) {
              if (ev.localPosition.dx <= widget.width / 2) {
                if (ev.localPosition.dy <= widget.height / 2) {
                  _anchorPoint = 0;
                } else {
                  _anchorPoint = 3;
                }
              } else {
                if (ev.localPosition.dy <= widget.height / 2) {
                  _anchorPoint = 1;
                } else {
                  _anchorPoint = 2;
                }
              }
              _animCont.forward();
            },
            onExit: (ev) {
              _animCont.reverse();
            },
            cursor: SystemMouseCursors.click,
            child: AnimatedBuilder(
              animation: _animCont,
              builder: (context, _) => SizedBox(
                width: widget.width,
                height: widget.height,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: _anchorPoint == 2 || _anchorPoint == 3 ? 0 : null,
                      right: _anchorPoint == 1 || _anchorPoint == 2 ? 0 : null,
                      top: _anchorPoint == 0 || _anchorPoint == 1 ? 0 : null,
                      left: _anchorPoint == 0 || _anchorPoint == 3 ? 0 : null,
                      child: Container(
                        width: _anim.value * widget.width,
                        height: _anim.value * widget.height,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: widget.stroke, color: widget.color),
                          borderRadius: BorderRadius.circular(widget.radius),
                          color: widget.color,
                        ),
                      ),
                    ),
                    Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: widget.stroke, color: widget.color),
                          borderRadius: BorderRadius.circular(widget.radius)),
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
