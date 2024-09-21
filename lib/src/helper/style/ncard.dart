import 'package:flutter/material.dart';

/// NCardStyle public class for card Style parameters passing to use in link preview style cards
/// <summary>
/// [bgColor] - Background color Properties of card view.
/// Default value is `Colors.white`
/// [elevation] - elevation of the card
/// Default value is `4.0`
/// [borderRadius] - border radius of the card
/// Default value is `BorderRadius.circular(10)`
/// [shadowColor] - color of the shadow of the card
/// Default value is `Colors.grey`
/// [width] - width of the card
/// [height] - height of the card
/// </summary>

class NCardStyle {
  // NCardStyle properties
  final Color bgColor;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final Color shadowColor;
  final double? width;
  final double? height;

// NCardStyle constructor
  NCardStyle({
    Color? bgColor,
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    this.width,
    this.height,
    this.shadowColor = Colors.grey,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(10),
        elevation = elevation ?? 4.0,
        bgColor = bgColor ?? Colors.white;
}
