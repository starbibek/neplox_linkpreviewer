import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/index.dart';
import 'package:url_launcher/url_launcher.dart';

import 'style/styles.dart';

/// NCardView is a widget that displays a card with link preview and options
@protected
class NCardView extends StatelessWidget {
  /// NCard View Constructor
  const NCardView({
    super.key,
    required this.snapshot,
    required this.linkPreviewOptions,
    required this.nTypographyStyle,
    required this.nCardStyle,
  });

  final ElementModel snapshot;
  final NLinkPreviewOptions linkPreviewOptions;
  final NTypographyStyle nTypographyStyle;
  final NCardStyle nCardStyle;

  @protected
  double calculateTextHeight(
      String text, double fontSize, double containerWidth, int maxLines) {
    // Assuming an average character width proportional to the font size (this can vary depending on the font)
    var avgCharWidth = fontSize * 0.6;

    // Estimate how many characters fit in one line based on container width
    var charsPerLine = containerWidth ~/ avgCharWidth;

    // Total number of lines needed (using the text length)
    var numLines = (text.length / charsPerLine).ceil();

    // Restrict the number of lines to the provided maxLines value
    numLines = numLines > maxLines ? maxLines : numLines;

    // Calculate the total height based on the number of lines and line height (assuming line height is 1.2 times font size)
    var lineHeight = fontSize * 1.2;
    return numLines * lineHeight;
  }

  @protected
  double calculateTotalHeight(
      String title,
      String body,
      double titleFontSize,
      double bodyFontSize,
      double containerWidth,
      double imageHeight,
      double imageWidth,
      int titleMaxLines,
      int bodyMaxLines) {
    // Calculate height for title and body text only once
    final titleHeight = calculateTextHeight(
        title, titleFontSize, containerWidth, titleMaxLines);
    final bodyHeight =
        calculateTextHeight(body, bodyFontSize, containerWidth, bodyMaxLines);

    // Calculate total height occupied by title, body, image, and padding
    // Total height occupied by title, body, image, and padding
    return titleHeight +
        bodyHeight +
        imageHeight +
        (imageWidth > 0
            ? (imageWidth - titleHeight - bodyHeight)
            : imageWidth) +
        17; // 17 is the padding/margin
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      /// Checking constraints max width is infinite or not.
      var cardWidth = constraints.maxWidth != double.infinity
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width * 0.95;

      double imgHeight = 0.0, imgWidth = 0.0;

      // Pre-calculate image size based on the thumbnail preview direction
      if ([NThumbnailPreviewDirection.bottom, NThumbnailPreviewDirection.top]
          .contains(linkPreviewOptions.thumbnailPreviewDirection)) {
        imgHeight = 0.5 * cardWidth;
      } else if ([
        NThumbnailPreviewDirection.ltr,
        NThumbnailPreviewDirection.rtl
      ].contains(linkPreviewOptions.thumbnailPreviewDirection)) {
        imgWidth = 0.3 * cardWidth;
      }

      /// Checking whether the max height is infinite.
      double cardHeight = constraints.maxHeight != double.infinity
          ? constraints.maxHeight
          : calculateTotalHeight(
              "${snapshot.title}", // Directly pass the title
              "${snapshot.description}", // Directly pass the description
              nTypographyStyle.titleFontSize,
              nTypographyStyle.bodyFontSize,
              cardWidth,
              imgHeight,
              imgWidth,
              nTypographyStyle.titleMaxLine,
              nTypographyStyle.bodyMaxLine,
            );

      return Material(
        clipBehavior: Clip.antiAlias,
        color: nCardStyle.bgColor,
        shadowColor: nCardStyle.shadowColor,
        elevation: nCardStyle.elevation,
        borderRadius: nCardStyle.borderRadius,
        child: InkWell(
          onTap: linkPreviewOptions.urlLaunch == NURLLaunch.enable
              ? () {
                  try {
                    launchUrl(Uri.parse("${snapshot.link}"),
                        mode: linkPreviewOptions.urlLaunchIn == NURLLaunchIn.app
                            ? LaunchMode.inAppWebView
                            : LaunchMode.externalApplication);
                  } catch (E) {
                    log(E.toString(), name: "NeploxLinkPreviewer");
                  }
                }
              : null,
          child: _views(context, linkPreviewOptions.thumbnailPreviewDirection,
              cardWidth, cardHeight),
        ),
      );
    });
  }

  _views(BuildContext context, NThumbnailPreviewDirection uiDirection,
      double maxWidth, double maxHeight) {
    switch (uiDirection) {
      // ignore: deprecated_member_use_from_same_package
      case NThumbnailPreviewDirection.none:
        return _normalView(
          context,
        );
      case NThumbnailPreviewDirection.normal:
        return _normalView(
          context,
        );
      case NThumbnailPreviewDirection.top:
        return _topView(context, maxWidth, maxHeight);
      case NThumbnailPreviewDirection.bottom:
        return _bottomView(context, maxWidth, maxHeight);
      case NThumbnailPreviewDirection.ltr:
        return _ltrView(context, maxWidth, maxHeight);
      case NThumbnailPreviewDirection.rtl:
        return _rtlView(context, maxWidth, maxHeight);
      default:
        return _normalView(
          context,
        );
    }
  }

  Widget _headerTextWidget(BuildContext context) {
    return Text(
      "${snapshot.title}",
      maxLines: nTypographyStyle.titleMaxLine,
      overflow: TextOverflow.ellipsis,
      style: nTypographyStyle.titleTextStyle ??
          TextStyle(
            fontSize: nTypographyStyle.titleFontSize,
            fontWeight: nTypographyStyle.titleFontWeight,
            color: nTypographyStyle.titleColor,
          ),
    );
  }

  Widget _bodyTextWidget(BuildContext context) {
    return Text(
      "${snapshot.description}",
      maxLines: nTypographyStyle.bodyMaxLine,
      overflow: TextOverflow.ellipsis,
      style: nTypographyStyle.bodyTextStyle ??
          TextStyle(
            fontSize: nTypographyStyle.bodyFontSize,
            // fontWeight: nTypographyStyle.bodyFontWeight,
            color: nTypographyStyle.bodyColor,
          ),
    );
  }

  /// Link View without thumbnails.
  Widget _normalView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerTextWidget(context),
          _bodyTextWidget(context),
        ],
      ),
    );
  }

  /// Link View thumbnails on top -> title -> body
  _topView(BuildContext context, double maxWidth, double maxHeight) {
    return SizedBox(
      width: maxWidth,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: 0.55 * maxHeight,
              minWidth: double.infinity,
            ),
            child: _imageView(context),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerTextWidget(
                  context,
                ),
                _bodyTextWidget(
                  context,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Link View tile-> body -> thumbnail
  Widget _bottomView(BuildContext context, double maxWidth, double maxHeight) {
    return SizedBox(
      width: maxWidth,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _headerTextWidget(
                  context,
                ),
                _bodyTextWidget(
                  context,
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: 0.55 * maxHeight,
              minWidth: double.infinity,
            ),
            child: _imageView(context),
          ),
        ],
      ),
    );
  }

  /// Link View Left to Right thumnail -> title and desc
  Widget _ltrView(BuildContext context, double maxWidth, double maxHeight) {
    return SizedBox(
      width: maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: maxWidth * 0.3,
            height: maxHeight,
            child: _imageView(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerTextWidget(
                    context,
                  ),
                  _bodyTextWidget(
                    context,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Link View Right to Left title and desc on left and thumbnail in the right
  Widget _rtlView(BuildContext context, double maxWidth, double maxHeight) {
    return SizedBox(
      width: maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerTextWidget(
                    context,
                  ),
                  _bodyTextWidget(
                    context,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: maxWidth * 0.3,
            height: maxHeight,
            child: _imageView(context),
          ),
        ],
      ),
    );
  }

  /// Image Holder for network images from metadata.
  Widget _imageView(BuildContext context) {
    return Image.network(
      "${snapshot.image}",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Text("Cannot Retrieved Image From Url"),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if ((loadingProgress?.expectedTotalBytes ?? 0) >=
            (loadingProgress?.expectedTotalBytes?.toInt() ?? 0)) {
          return child;
        } else {
          return SizedBox(
            width: nCardStyle.width,
            height: nCardStyle.height,
            child: Center(
              child: CircularProgressIndicator.adaptive(
                // Handle potential division by zero
                value: loadingProgress?.expectedTotalBytes != null &&
                        loadingProgress!.expectedTotalBytes! > 0
                    ? (loadingProgress.cumulativeBytesLoaded) /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        }
      },
    );
  }
}
