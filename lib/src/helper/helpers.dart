import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/helper/style/styles.dart';

/// NURLLaunch enum to define link is clickable or not
/// <summary>
/// [enable] - Enable the URL launch.
/// [disable] - Disable the URL launch.
/// </summary>
enum NURLLaunch { enable, disable }

/// NURLLaunchIn enum to define url lauch methods
/// <summary>
/// [browser] - Launch the URL in the browser.
/// [app] - Launch the URL in the app.
/// [none] - Don't launch the URL.
/// </summary>
enum NURLLaunchIn { browser, app, none }

/// NThumbnailPreviewDirection enum for links preview direction.
/// <summary>
/// [normal] - No thumbnail preview.
/// [top] - Thumbnail preview in the top middle.
/// [bottom] - Thumbnail preview in the bottom middle.
/// [ltr] - Thumbnail preview in the left middle.
/// [rtl] - Thumbnail preview in the right middle.
/// </summary>
enum NThumbnailPreviewDirection {
  rtl,
  ltr,
  @Deprecated("Instead use normal")
  none,
  normal,
  top,
  bottom
}

/// NLinkPreviewOptions public class with properties to configure url launch
/// <summary>
/// [urlLaunch] - Options to configure url launch
/// [urlLaunchIn] - Options to configure url launch methods
/// [thumbnailPreviewDirection] - Options to configure link preview direction
/// </summary>
class NLinkPreviewOptions {
  final NURLLaunch urlLaunch;
  final NURLLaunchIn urlLaunchIn;
  final NThumbnailPreviewDirection thumbnailPreviewDirection;
  NLinkPreviewOptions({
    /// This is the constructor for the [NLinkPreviewOptions] class.
    ///
    /// [urlLaunch] - Enable or disable the URL launch. Default is [NURLLaunch.enable].
    this.urlLaunch = NURLLaunch.enable,

    /// [urlLaunchIn] - Launch the URL in the browser or app. Default is [NURLLaunchIn.browser].
    this.urlLaunchIn = NURLLaunchIn.browser,

    /// [thumbnailPreviewDirection] - The direction of the thumbnail preview. Default is [NThumbnailPreviewDirection.ltr].
    this.thumbnailPreviewDirection = NThumbnailPreviewDirection.ltr,
  });

  double getCardHeight(BuildContext context, NCardStyle nCardStyle) {
    switch (thumbnailPreviewDirection) {
      case NThumbnailPreviewDirection.top:
        return nCardStyle.height ?? 0.3 * MediaQuery.of(context).size.height;
      case NThumbnailPreviewDirection.bottom:
        return nCardStyle.height ?? 0.3 * MediaQuery.of(context).size.height;
      case NThumbnailPreviewDirection.ltr:
        return nCardStyle.height ?? 0.3 * MediaQuery.of(context).size.width;
      case NThumbnailPreviewDirection.rtl:
        return nCardStyle.height ?? 0.3 * MediaQuery.of(context).size.width;
      case NThumbnailPreviewDirection.normal:
        return nCardStyle.height ?? 0.28 * MediaQuery.of(context).size.width;
      // ignore: deprecated_member_use_from_same_package
      case NThumbnailPreviewDirection.none:
        return nCardStyle.height ?? 0.28 * MediaQuery.of(context).size.width;
      default:
        return nCardStyle.height ?? 0.28 * MediaQuery.of(context).size.width;
    }
  }
}
// END NLinkPreviewOptions.

// BEGIN SizeProvider.
extension SizeProvider on double {
  sres(BuildContext context) {
    return (MediaQuery.of(context).size.width * this) +
        (MediaQuery.of(context).size.height * this);
  }

  sh(BuildContext context) => MediaQuery.of(context).size.height * this;
  sw(BuildContext context) => MediaQuery.of(context).size.width * this;
}
// END SizeProvider.

// BEGIN StringExtension.
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
// END StringExtension.
