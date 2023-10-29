import 'package:flutter/widgets.dart';

class TouchPointer {
  double? touchSize;
  Offset? offset;
}

class TouchDetector extends StatelessWidget {
  const TouchDetector({
    super.key,
    required this.touchPointer,
    required this.child,
  });

  final TouchPointer touchPointer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enabled = touchPointer.touchSize! > 0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: enabled
          ? (details) => touchPointer.offset = details.localPosition
          : null,
      onPanUpdate: enabled
          ? (details) => touchPointer.offset = details.localPosition
          : null,
      onPanEnd: enabled ? (details) => touchPointer.offset = null : null,
      child: child,
    );
  }
}
