import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Builds a simple leaf shape with pointed ends, growing upwards from
/// [origin] and rotated clockwise by [angle] radians.
Path buildLeaf({
  required Offset origin,
  required double length,
  required double width,
  double angle = 0,
}) {
  final path = Path()
    ..moveTo(0, 0)
    ..quadraticBezierTo(width, -length * 0.38, 0, -length)
    ..quadraticBezierTo(-width, -length * 0.38, 0, 0)
    ..close();

  final matrix = Matrix4.identity()
    ..translateByDouble(origin.dx, origin.dy, 0, 1)
    ..rotateZ(angle);
  return path.transform(matrix.storage);
}

/// The soft vein that runs through the middle of a leaf.
Path buildLeafVein({
  required Offset origin,
  required double length,
  required double width,
  double angle = 0,
}) {
  final path = Path()
    ..moveTo(0, -length * 0.08)
    ..quadraticBezierTo(width * 0.32, -length * 0.45, 0, -length * 0.9);

  final matrix = Matrix4.identity()
    ..translateByDouble(origin.dx, origin.dy, 0, 1)
    ..rotateZ(angle);
  return path.transform(matrix.storage);
}

/// Draws a filled leaf together with its lighter vein.
void paintLeaf(
  Canvas canvas, {
  required Offset origin,
  required double length,
  required double width,
  double angle = 0,
  Color color = AppColors.leafGreen,
  Color veinColor = AppColors.leafHighlight,
}) {
  canvas.drawPath(
    buildLeaf(origin: origin, length: length, width: width, angle: angle),
    Paint()..color = color,
  );
  canvas.drawPath(
    buildLeafVein(origin: origin, length: length, width: width, angle: angle),
    Paint()
      ..color = veinColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, length * 0.035)
      ..strokeCap = StrokeCap.round,
  );
}

/// Fills [path] with a linear gradient spanning its own bounds, the way an
/// SVG `objectBoundingBox` gradient behaves.
void fillGradient(
  Canvas canvas,
  Path path,
  Color from,
  Color to, {
  bool horizontal = false,
}) {
  final shader = LinearGradient(
    begin: horizontal ? Alignment.centerLeft : Alignment.topLeft,
    end: horizontal ? Alignment.centerRight : Alignment.bottomRight,
    colors: [from, to],
  ).createShader(path.getBounds());
  canvas.drawPath(path, Paint()..shader = shader);
}
