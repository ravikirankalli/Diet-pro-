import 'package:flutter/material.dart';

final RegExp _token = RegExp(r'[A-Za-z]|-?\d*\.?\d+');

/// Builds a [Path] from the `M`/`L`/`C`/`Z` subset of SVG path data that the
/// design files use. Coordinates are multiplied by [sx] and [sy], so the same
/// data serves any screen size.
Path buildSvgPath(String d, double sx, double sy) {
  final tokens = _token.allMatches(d).map((m) => m.group(0)!).toList();
  final path = Path();
  var i = 0;
  var command = 'M';
  double next(double scale) => double.parse(tokens[i++]) * scale;

  while (i < tokens.length) {
    final token = tokens[i];
    if (token.length == 1 && RegExp(r'[A-Za-z]').hasMatch(token)) {
      command = token;
      i++;
      if (command == 'Z' || command == 'z') {
        path.close();
        continue;
      }
    }
    switch (command) {
      case 'M':
        path.moveTo(next(sx), next(sy));
        // A second coordinate pair after a moveto is an implicit lineto.
        command = 'L';
      case 'L':
        path.lineTo(next(sx), next(sy));
      case 'C':
        path.cubicTo(
          next(sx),
          next(sy),
          next(sx),
          next(sy),
          next(sx),
          next(sy),
        );
      default:
        i++;
    }
  }
  return path;
}

/// One filled shape from a design SVG.
class ArtPath {
  const ArtPath(this.d, this.fill, {this.anchorY});

  /// SVG path data, with the file's own transform already applied.
  final String d;
  final Color fill;

  /// When set, the shape keeps its own proportions (scaled by width) and is
  /// pinned at this y in design space, so small details such as leaves are
  /// not stretched on a tall screen. When null the shape stretches to fill
  /// the screen, which is what the large background curves want.
  final double? anchorY;
}

/// Paints [shapes] scaled from a design view box onto the whole canvas.
void paintArt(
  Canvas canvas,
  Size size,
  List<ArtPath> shapes, {
  required double viewWidth,
  required double viewHeight,
}) {
  final sx = size.width / viewWidth;
  final sy = size.height / viewHeight;

  for (final shape in shapes) {
    final anchorY = shape.anchorY;
    final path = anchorY == null
        ? buildSvgPath(shape.d, sx, sy)
        : buildSvgPath(shape.d, sx, sx).shift(Offset(0, anchorY * (sy - sx)));
    canvas.drawPath(path, Paint()..color = shape.fill);
  }
}
