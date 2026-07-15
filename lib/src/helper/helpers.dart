import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/helper/style/styles.dart';

/// Whether tapping a preview card launches its URL.
enum NURLLaunch {
  /// Make the card interactive.
  enable,

  /// Render the card without a tap action.
  disable,
}

/// Where an enabled preview opens its URL.
enum NURLLaunchIn {
  /// Open with an external browser or the platform's default application.
  browser,

  /// Open inside the application using an in-app web view.
  app,

  /// Do not launch a URL, even when [NURLLaunch.enable] is selected.
  none,
}

/// Placement of the preview thumbnail relative to its text.
enum NThumbnailPreviewDirection {
  /// Place the thumbnail on the right.
  rtl,

  /// Place the thumbnail on the left.
  ltr,

  /// Legacy name for [normal].
  @Deprecated('Use normal instead.')
  none,

  /// Show title and description without a thumbnail.
  normal,

  /// Place the thumbnail above the text.
  top,

  /// Place the thumbnail below the text.
  bottom,
}

/// Interaction and thumbnail-layout options for a link preview.
class NLinkPreviewOptions {
  NLinkPreviewOptions({
    this.urlLaunch = NURLLaunch.enable,
    this.urlLaunchIn = NURLLaunchIn.browser,
    this.thumbnailPreviewDirection = NThumbnailPreviewDirection.ltr,
  });

  /// Whether the card responds to taps.
  final NURLLaunch urlLaunch;

  /// Where the URL opens when launching is enabled.
  final NURLLaunchIn urlLaunchIn;

  /// Requested thumbnail placement.
  ///
  /// The rendered layout may adapt on very narrow or short cards.
  final NThumbnailPreviewDirection thumbnailPreviewDirection;

  /// Calculates the direction-aware height used by fixed-height cards.
  ///
  /// Returns [NCardStyle.height] when explicitly configured.
  double getCardHeight(BuildContext context, NCardStyle nCardStyle) {
    switch (thumbnailPreviewDirection) {
      case NThumbnailPreviewDirection.top:
      case NThumbnailPreviewDirection.bottom:
        return nCardStyle.height ?? 0.3 * MediaQuery.sizeOf(context).height;
      case NThumbnailPreviewDirection.ltr:
      case NThumbnailPreviewDirection.rtl:
        return nCardStyle.height ?? 0.3 * MediaQuery.sizeOf(context).width;
      case NThumbnailPreviewDirection.normal:
      // ignore: deprecated_member_use_from_same_package
      case NThumbnailPreviewDirection.none:
        return nCardStyle.height ?? 0.28 * MediaQuery.sizeOf(context).width;
    }
  }
}

/// Responsive size helpers retained for backward compatibility.
extension SizeProvider on double {
  /// Scales this value by the sum of screen width and height.
  double sres(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return (size.width * this) + (size.height * this);
  }

  /// Returns this fraction of the screen height.
  double sh(BuildContext context) => MediaQuery.sizeOf(context).height * this;

  /// Returns this fraction of the screen width.
  double sw(BuildContext context) => MediaQuery.sizeOf(context).width * this;
}

/// General string helpers retained for backward compatibility.
extension StringExtension on String {
  /// Uppercases the first UTF-16 code unit, leaving an empty string unchanged.
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
