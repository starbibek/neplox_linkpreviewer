import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:neplox_linkpreviewer/src/helper/helpers.dart';
import 'package:neplox_linkpreviewer/src/model/element_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'style/styles.dart';

/// Internal Material card used by the public link preview widget.
@protected
class NCardView extends StatelessWidget {
  const NCardView({
    super.key,
    required this.snapshot,
    required this.linkPreviewOptions,
    required this.nTypographyStyle,
    required this.nCardStyle,
    this.wrapContent = false,
  });

  final ElementModel snapshot;
  final NLinkPreviewOptions linkPreviewOptions;
  final NTypographyStyle nTypographyStyle;
  final NCardStyle nCardStyle;
  final bool wrapContent;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: nCardStyle.bgColor,
      shadowColor: nCardStyle.shadowColor,
      elevation: nCardStyle.elevation,
      borderRadius: nCardStyle.borderRadius,
      child: InkWell(
        onTap: _canLaunch ? _launch : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final direction = _responsiveDirection(
              linkPreviewOptions.thumbnailPreviewDirection,
              constraints,
            );
            if (wrapContent) {
              return _wrappedView(direction, constraints.maxWidth);
            }
            return _view(direction, constraints);
          },
        ),
      ),
    );
  }

  bool get _canLaunch =>
      linkPreviewOptions.urlLaunch == NURLLaunch.enable &&
      linkPreviewOptions.urlLaunchIn != NURLLaunchIn.none &&
      snapshot.link != null;

  Future<void> _launch() async {
    final uri = Uri.tryParse(snapshot.link ?? '');
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) return;

    try {
      final launched = await launchUrl(
        uri,
        mode: linkPreviewOptions.urlLaunchIn == NURLLaunchIn.app
            ? LaunchMode.inAppWebView
            : LaunchMode.externalApplication,
      );
      if (!launched) {
        log('No application could open $uri', name: 'NeploxLinkPreviewer');
      }
    } on Object catch (error, stackTrace) {
      log(
        'Could not open $uri',
        name: 'NeploxLinkPreviewer',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  NThumbnailPreviewDirection _responsiveDirection(
    NThumbnailPreviewDirection direction,
    BoxConstraints constraints,
  ) {
    final horizontal = direction == NThumbnailPreviewDirection.ltr ||
        direction == NThumbnailPreviewDirection.rtl;
    final vertical = direction == NThumbnailPreviewDirection.top ||
        direction == NThumbnailPreviewDirection.bottom;

    if (horizontal && constraints.maxWidth < 240) {
      return constraints.maxHeight >= 120
          ? NThumbnailPreviewDirection.top
          : NThumbnailPreviewDirection.normal;
    }
    if (vertical && constraints.maxHeight < 120) {
      return constraints.maxWidth >= 240
          ? NThumbnailPreviewDirection.ltr
          : NThumbnailPreviewDirection.normal;
    }
    return direction;
  }

  Widget _view(
    NThumbnailPreviewDirection direction,
    BoxConstraints constraints,
  ) {
    switch (direction) {
      // ignore: deprecated_member_use_from_same_package
      case NThumbnailPreviewDirection.none:
      case NThumbnailPreviewDirection.normal:
        return _textContent();
      case NThumbnailPreviewDirection.top:
        return Column(children: [
          _verticalImage(constraints.maxHeight),
          Expanded(child: _textContent()),
        ]);
      case NThumbnailPreviewDirection.bottom:
        return Column(children: [
          Expanded(child: _textContent()),
          _verticalImage(constraints.maxHeight),
        ]);
      case NThumbnailPreviewDirection.ltr:
        return Row(children: [
          _horizontalImage(constraints.maxWidth),
          Expanded(child: _textContent()),
        ]);
      case NThumbnailPreviewDirection.rtl:
        return Row(children: [
          Expanded(child: _textContent()),
          _horizontalImage(constraints.maxWidth),
        ]);
    }
  }

  Widget _wrappedView(
    NThumbnailPreviewDirection direction,
    double availableWidth,
  ) {
    switch (direction) {
      // ignore: deprecated_member_use_from_same_package
      case NThumbnailPreviewDirection.none:
      case NThumbnailPreviewDirection.normal:
        return _wrappedTextContent();
      case NThumbnailPreviewDirection.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: nCardStyle.thumbnailAspectRatio,
              child: _image(),
            ),
            _wrappedTextContent(),
          ],
        );
      case NThumbnailPreviewDirection.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _wrappedTextContent(),
            AspectRatio(
              aspectRatio: nCardStyle.thumbnailAspectRatio,
              child: _image(),
            ),
          ],
        );
      case NThumbnailPreviewDirection.ltr:
        return _wrappedSideView(availableWidth, imageFirst: true);
      case NThumbnailPreviewDirection.rtl:
        return _wrappedSideView(availableWidth, imageFirst: false);
    }
  }

  Widget _wrappedSideView(double availableWidth, {required bool imageFirst}) {
    final image = SizedBox(
      width: availableWidth * nCardStyle.horizontalThumbnailFraction,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 96),
        child: _image(),
      ),
    );
    final text = Expanded(child: _wrappedTextContent());

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: imageFirst ? [image, text] : [text, image],
      ),
    );
  }

  Widget _horizontalImage(double availableWidth) {
    return SizedBox(
      width: availableWidth * nCardStyle.horizontalThumbnailFraction,
      height: double.infinity,
      child: _image(),
    );
  }

  Widget _verticalImage(double availableHeight) {
    return SizedBox(
      width: double.infinity,
      height: availableHeight * nCardStyle.verticalThumbnailFraction,
      child: _image(),
    );
  }

  Widget _textContent() {
    return Padding(
      padding: nCardStyle.contentPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasText(snapshot.title)) Flexible(child: _title()),
          if (_hasText(snapshot.title) && _hasText(snapshot.description))
            SizedBox(height: nCardStyle.textSpacing),
          if (_hasText(snapshot.description))
            Expanded(
                child:
                    Align(alignment: Alignment.topLeft, child: _description())),
        ],
      ),
    );
  }

  Widget _wrappedTextContent() {
    return Padding(
      padding: nCardStyle.contentPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasText(snapshot.title)) _title(),
          if (_hasText(snapshot.title) && _hasText(snapshot.description))
            SizedBox(height: nCardStyle.textSpacing),
          if (_hasText(snapshot.description)) _description(),
        ],
      ),
    );
  }

  Widget _title() {
    return Text(
      snapshot.title!,
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

  Widget _description() {
    return Text(
      snapshot.description!,
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

  Widget _image() {
    final imageUri = Uri.tryParse(snapshot.image ?? '');
    if (imageUri == null ||
        (imageUri.scheme != 'http' && imageUri.scheme != 'https')) {
      return const _ImageFallback();
    }

    return Image.network(
      imageUri.toString(),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const _ImageFallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        final total = progress.expectedTotalBytes;
        return Center(
          child: CircularProgressIndicator.adaptive(
            value: total == null || total <= 0
                ? null
                : progress.cumulativeBytesLoaded / total,
          ),
        );
      },
    );
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.link)),
    );
  }
}
