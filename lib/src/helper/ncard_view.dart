import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/helper/responsive/responsive_card_view.dart';
import 'package:neplox_linkpreviewer/src/index.dart';

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

  final LinkMetadata snapshot;
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
    switch (linkPreviewOptions.thumbnailPreviewDirection) {
      case NThumbnailPreviewDirection.ltr:
        return HorizontalCardView(
          cardStyle: nCardStyle,
          typography: nTypographyStyle,
          thumbnail: _imageView(context),
          content: _contentView(context),
          isRTL: false,
        );

      case NThumbnailPreviewDirection.rtl:
        return HorizontalCardView(
          cardStyle: nCardStyle,
          typography: nTypographyStyle,
          thumbnail: _imageView(context),
          content: _contentView(context),
          isRTL: true,
        );

      case NThumbnailPreviewDirection.top:
        return VerticalCardView(
          cardStyle: nCardStyle,
          typography: nTypographyStyle,
          thumbnail: _imageView(context),
          content: _contentView(context),
          thumbnailOnTop: true,
        );

      case NThumbnailPreviewDirection.bottom:
        return VerticalCardView(
          cardStyle: nCardStyle,
          typography: nTypographyStyle,
          thumbnail: _imageView(context),
          content: _contentView(context),
          thumbnailOnTop: false,
        );

      default:
        return _normalView(context);
    }
  }

  Widget _contentView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 2,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerTextWidget(context),
          _bodyTextWidget(context),
        ],
      ),
    );
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
            fontWeight: nTypographyStyle.bodyFontWeight,
            color: nTypographyStyle.bodyColor,
          ),
    );
  }

  /// Link View without thumbnails.
  Widget _normalView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _headerTextWidget(context),
          _bodyTextWidget(context),
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
