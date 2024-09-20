import 'package:flutter/material.dart';

/// NCardStyle public class for card Style parameters passing to use in link preview style cards
/// <summary>
/// [bgColor] - color of the background of the card
/// [elevation] - elevation of the card
/// [borderRadius] - border radius of the card
/// [shadowColor] - color of the shadow of the card
/// </summary>

class NCardStyle {
  // NCardStyle properties
  final Color bgColor;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final Color shadowColor;

// NCardStyle constructor
  NCardStyle({
    required this.bgColor,
    this.elevation = 4.0,
    BorderRadiusGeometry? borderRadius,
    this.shadowColor = Colors.grey,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(10);
}
