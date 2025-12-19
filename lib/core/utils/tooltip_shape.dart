import 'package:flutter/material.dart';

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const double arrowWidth = 16;
    const double arrowHeight = 12;
    const double radius = 12;

    final Path path = Path();

    path.moveTo(rect.right - radius - arrowWidth / 2, rect.top);
    path.lineTo(rect.right - radius, rect.top - arrowHeight);
    path.lineTo(rect.right - radius + arrowWidth / 2, rect.top);

    path.lineTo(rect.right - radius, rect.top);
    path.arcToPoint(Offset(rect.right, rect.top + radius),
        radius: const Radius.circular(radius));

    path.lineTo(rect.right, rect.bottom - radius);
    path.arcToPoint(Offset(rect.right - radius, rect.bottom),
        radius: const Radius.circular(radius));

    path.lineTo(rect.left + radius, rect.bottom);
    path.arcToPoint(Offset(rect.left, rect.bottom - radius),
        radius: const Radius.circular(radius));

    path.lineTo(rect.left, rect.top + radius);
    path.arcToPoint(Offset(rect.left + radius, rect.top),
        radius: const Radius.circular(radius));

    path.lineTo(rect.right - radius - arrowWidth / 2, rect.top);

    path.close();
    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
