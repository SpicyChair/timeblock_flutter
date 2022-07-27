import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectableItem extends StatefulWidget {
  const SelectableItem({
    Key? key,
    required this.index,
    required this.color,
    required this.selected,
    this.radius = BorderRadius.zero,
  }) : super(key: key);

  final int index;
  final Color color;
  final bool selected;
  final BorderRadius radius;

  @override
  _SelectableItemState createState() => _SelectableItemState();
}

class _SelectableItemState extends State<SelectableItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: widget.selected ? 1 : 0,
      duration: const Duration(milliseconds: 275),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(SelectableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
        HapticFeedback.mediumImpact();
      } else {
        _controller.reverse();
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: calculateColor(),
              borderRadius: widget.radius,
            ),
            child: child,
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "",//'${widget.index}',

          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color? calculateColor() {
    return Color.lerp(
      widget.color,
      widget.color.withAlpha(64),
      _controller.value,
    );
  }
}