import 'package:flutter/material.dart';

/// This file contains all the helper functions and classes
/// used in the app.
/// This file is part of the NURL project.
///
/// [enable] - Enable the URL launch.
///
/// [disable] - Disable the URL launch.
enum NURLLaunch { enable, disable }

/// [browser] - Launch the URL in the browser.
///
/// [app] - Launch the URL in the app.
///
/// [none] - Don't launch the URL.
enum NURLLaunchIn { browser, app, none }

/// [image] - The URL is an image.
///
/// [video] - The URL is a video.
///
/// [audio] - The URL is an audio.
///
/// [file] - The URL is a file.
///
/// [url] - The URL is a URL.
enum NURLContentType { image, video, audio, file, url }

/// [rtl] - Thumbnail preview in right and title and description to left.
///
/// [ltr] - Thumbnail preview in left and title and description to right.
///
/// [none] - No thumbnail preview.\n
///
/// [top] - Thumbnail preview in the top middle.\n
///
/// [bottom] - Thumbnail preview in the bottom middle.\n
enum NThumbnailPreviewDirection { rtl, ltr, none, top, bottom }

enum NDecoration { none, box, shadow, boxShadow }

// BEGIN NLinkPreviewOptions.
class NLinkPreviewOptions {
  NURLLaunch urlLaunch;
  NURLLaunchIn urlLaunchIn;
  NThumbnailPreviewDirection thumbnailPreviewDirection;
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