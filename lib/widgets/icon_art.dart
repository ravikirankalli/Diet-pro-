import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Draws an icon from assets, picking the right widget for the format.
/// The supplied artwork is a mix of vector and raster files.
class IconArt extends StatelessWidget {
  const IconArt(this.asset, {super.key});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return asset.endsWith('.svg')
        ? SvgPicture.asset(asset, fit: BoxFit.contain)
        : Image.asset(
            asset,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
          );
  }
}
