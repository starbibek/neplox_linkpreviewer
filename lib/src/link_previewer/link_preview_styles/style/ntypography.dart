import 'package:flutter/material.dart';

/// Public TypographyStyle class for link previewer text styling
/// <summary>
/// [titleFontSize] is the font size of the title
/// [titleFontWeight] is the font weight property of the title
/// [titleColor] is the color of the title
/// [titleMaxLine] is the maxline of the title
/// [titleTextStyle]  it TextStyle for the title
/// [bodyFontSize] is the font size of the body text
/// [bodyFontWeight] is the font weight property of the body text
/// [bodyColor] is the color of the body content
/// [bodyMaxLine] is the maxline of the body text
/// [bodyTextStyle] is TextStyle for body text

class NTypographyStyle {
  // NTypographyStyle title properties
  final double? titleFontSize;
  final double? titleFontWeight;
  final Color? titleColor;
  final int? titleMaxLine;
  final TextStyle? titleTextStyle;

  // NTypographyStyle body properties
  final double? bodyFontSize;
  final double? bodyFontWeight;
  final Color? bodyColor;
  final int? bodyMaxLine;
  final TextStyle? bodyTextStyle;

// NTypographyStyle Constructor
  NTypographyStyle({
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleMaxLine,
    this.titleTextStyle,
    this.bodyColor,
    this.bodyFontSize,
    this.bodyFontWeight,
    this.bodyMaxLine,
    this.bodyTextStyle,
  });
}
