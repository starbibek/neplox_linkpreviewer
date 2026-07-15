import 'package:flutter/material.dart';

/// Determines how a preview card chooses its vertical size.
enum NCardHeightMode {
  /// Uses [NCardStyle.height], or the package's direction-aware default height.
  fixed,

  /// Wraps title and description content and grows as their lines increase.
  contentWrap,
}

/// Visual and responsive layout settings for a link-preview card.
class NCardStyle {
  NCardStyle({
    Color? bgColor,
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    this.width,
    this.height,
    this.shadowColor = Colors.grey,
    this.contentPadding = const EdgeInsets.all(12),
    this.textSpacing = 6,
    this.horizontalThumbnailFraction = 0.32,
    this.verticalThumbnailFraction = 0.5,
    this.heightMode = NCardHeightMode.fixed,
    this.minHeight = 0,
    this.thumbnailAspectRatio = 16 / 9,
  })  : assert(
            horizontalThumbnailFraction > 0 && horizontalThumbnailFraction < 1),
        assert(verticalThumbnailFraction > 0 && verticalThumbnailFraction < 1),
        assert(textSpacing >= 0),
        assert(minHeight >= 0),
        assert(thumbnailAspectRatio > 0),
        borderRadius = borderRadius ?? BorderRadius.circular(12),
        elevation = elevation ?? 2,
        bgColor = bgColor ?? Colors.white;

  /// Card background color.
  final Color bgColor;

  /// Material elevation. Defaults to `2` for a lighter adaptive surface.
  final double elevation;

  /// Card clipping and ink-response radius.
  final BorderRadiusGeometry borderRadius;

  /// Material shadow color.
  final Color shadowColor;

  /// Explicit card width. When omitted, the preview uses available screen width.
  final double? width;

  /// Explicit card height. When omitted, a direction-aware height is used.
  final double? height;

  /// Whether height is fixed or determined by wrapped content.
  final NCardHeightMode heightMode;

  /// Minimum height used by [NCardHeightMode.contentWrap].
  final double minHeight;

  /// Thumbnail aspect ratio in top/bottom content-wrap layouts.
  final double thumbnailAspectRatio;

  /// Padding around the title and description.
  final EdgeInsetsGeometry contentPadding;

  /// Vertical space between title and description.
  final double textSpacing;

  /// Width reserved for thumbnails in left and right layouts.
  final double horizontalThumbnailFraction;

  /// Height reserved for thumbnails in top and bottom layouts.
  final double verticalThumbnailFraction;

  /// Returns a style with selected values replaced.
  NCardStyle copyWith({
    Color? bgColor,
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    Color? shadowColor,
    double? width,
    double? height,
    EdgeInsetsGeometry? contentPadding,
    double? textSpacing,
    double? horizontalThumbnailFraction,
    double? verticalThumbnailFraction,
    NCardHeightMode? heightMode,
    double? minHeight,
    double? thumbnailAspectRatio,
  }) {
    return NCardStyle(
      bgColor: bgColor ?? this.bgColor,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      shadowColor: shadowColor ?? this.shadowColor,
      width: width ?? this.width,
      height: height ?? this.height,
      contentPadding: contentPadding ?? this.contentPadding,
      textSpacing: textSpacing ?? this.textSpacing,
      horizontalThumbnailFraction:
          horizontalThumbnailFraction ?? this.horizontalThumbnailFraction,
      verticalThumbnailFraction:
          verticalThumbnailFraction ?? this.verticalThumbnailFraction,
      heightMode: heightMode ?? this.heightMode,
      minHeight: minHeight ?? this.minHeight,
      thumbnailAspectRatio: thumbnailAspectRatio ?? this.thumbnailAspectRatio,
    );
  }
}
