import 'package:flutter/material.dart';

/// Typography configuration for preview titles and descriptions.
///
/// When [titleTextStyle] or [bodyTextStyle] is supplied, that complete style is
/// used instead of the corresponding size, weight, and color properties.
class NTypographyStyle {
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
  })  : assert((titleMaxLine ?? 2) > 0),
        assert((bodyMaxLine ?? 4) > 0),
        titleMaxLine = titleMaxLine ?? 2,
        titleColor = titleColor ?? Colors.grey.shade800,
        titleFontSize = titleFontSize ?? 16,
        titleFontWeight = titleFontWeight ?? FontWeight.w500,
        bodyMaxLine = bodyMaxLine ?? 4,
        bodyColor = bodyColor ?? Colors.grey.shade500,
        bodyFontSize = bodyFontSize ?? 10,
        bodyFontWeight = bodyFontWeight ?? FontWeight.normal;

  /// Title font size used when [titleTextStyle] is null.
  final double titleFontSize;

  /// Title weight used when [titleTextStyle] is null.
  final FontWeight titleFontWeight;

  /// Title color used when [titleTextStyle] is null.
  final Color titleColor;

  /// Maximum number of displayed title lines.
  final int titleMaxLine;

  /// Complete optional title style.
  final TextStyle? titleTextStyle;

  /// Description font size used when [bodyTextStyle] is null.
  final double bodyFontSize;

  /// Description weight used when [bodyTextStyle] is null.
  final FontWeight bodyFontWeight;

  /// Description color used when [bodyTextStyle] is null.
  final Color bodyColor;

  /// Maximum number of displayed description lines.
  final int bodyMaxLine;

  /// Complete optional description style.
  final TextStyle? bodyTextStyle;

  /// Returns a configuration with selected values replaced.
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
  }) {
    return NTypographyStyle(
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
}
