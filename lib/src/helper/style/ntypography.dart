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
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final Color titleColor;
  final int titleMaxLine;
  final TextStyle? titleTextStyle;

  // NTypographyStyle body properties
  final double bodyFontSize;
  final FontWeight bodyFontWeight;
  final Color bodyColor;
  final int bodyMaxLine;
  final TextStyle? bodyTextStyle;

// NTypographyStyle Constructor
  NTypographyStyle({
    Color? titleColor,
    double? titleFontSize,
    FontWeight? titleFontWeight,
    int? titleMaxLine,
    this.titleTextStyle,
    Color? bodyColor,
    double? bodyFontSize,
    FontWeight? bodyFontWeight,
    int? bodyMaxLine,
    this.bodyTextStyle,
  })  : titleMaxLine = titleMaxLine ?? 2,
        titleColor = titleColor ?? Colors.grey.shade800,
        titleFontSize = titleFontSize ?? 16,
        titleFontWeight = titleFontWeight ?? FontWeight.w500,
        bodyMaxLine = bodyMaxLine ?? 4,
        bodyColor = bodyColor ?? Colors.grey.shade500,
        bodyFontSize = bodyFontSize ?? 10,
        bodyFontWeight = bodyFontWeight ?? FontWeight.normal;

  NTypographyStyle copyWith({
    Color? titleColor,
    double? titleFontSize,
    FontWeight? titleFontWeight,
    int? titleMaxLine,
    TextStyle? titleTextStyle,
    Color? bodyColor,
    double? bodyFontSize,
    FontWeight? bodyFontWeight,
    int? bodyMaxLine,
    TextStyle? bodyTextStyle,
  }) =>
      NTypographyStyle(
        bodyColor: bodyColor ?? this.bodyColor,
        bodyFontSize: bodyFontSize ?? this.bodyFontSize,
        bodyFontWeight: bodyFontWeight ?? this.bodyFontWeight,
        bodyMaxLine: bodyMaxLine ?? this.bodyMaxLine,
        bodyTextStyle: bodyTextStyle ?? this.bodyTextStyle,
        titleColor: titleColor ?? this.titleColor,
        titleFontSize: titleFontSize ?? this.titleFontSize,
        titleFontWeight: titleFontWeight ?? this.titleFontWeight,
        titleMaxLine: titleMaxLine ?? this.titleMaxLine,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      );
}
