import 'package:flutter/material.dart';

import '../style/styles.dart';
import 'device_layout.dart';

/// Base class for responsive card layouts
abstract class ResponsiveCardView extends StatelessWidget {
  final NCardStyle cardStyle;
  final NTypographyStyle typography;

  const ResponsiveCardView({
    super.key,
    required this.cardStyle,
    required this.typography,
  });

  @protected
  Widget buildMobileLayout(BuildContext context);

  @protected
  Widget buildTabletLayout(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return DeviceLayout.isTablet(context)
        ? buildTabletLayout(context)
        : buildMobileLayout(context);
  }
}

/// Horizontal card layout implementation
class HorizontalCardView extends ResponsiveCardView {
  final Widget thumbnail;
  final Widget content;
  final bool isRTL;

  const HorizontalCardView({
    super.key,
    required super.cardStyle,
    required super.typography,
    required this.thumbnail,
    required this.content,
    this.isRTL = false,
  });

  @override
  Widget buildMobileLayout(BuildContext context) {
    return SizedBox(
      width: DeviceLayout.getCardWidth(context),
      height: DeviceLayout.getInlineContentHeight(context),
      child: Row(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          SizedBox(
            width: DeviceLayout.getCardWidth(context) * 0.3,
            height: DeviceLayout.getInlineContentHeight(context),
            child: thumbnail,
          ),
          Expanded(child: content),
        ],
      ),
    );
  }

  @override
  Widget buildTabletLayout(BuildContext context) {
    return SizedBox(
      width: DeviceLayout.getCardWidth(context),
      height: DeviceLayout.getInlineContentHeight(context),
      child: Row(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          SizedBox(
            width: DeviceLayout.getCardWidth(context) * 0.25,
            height: DeviceLayout.getInlineContentHeight(context),
            child: thumbnail,
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

/// Vertical card layout implementation
class VerticalCardView extends ResponsiveCardView {
  final Widget thumbnail;
  final Widget content;
  final bool thumbnailOnTop;

  const VerticalCardView({
    super.key,
    required super.cardStyle,
    required super.typography,
    required this.thumbnail,
    required this.content,
    this.thumbnailOnTop = true,
  });

  @override
  Widget buildMobileLayout(BuildContext context) {
    final children = [
      SizedBox(
        width: double.infinity,
        height: DeviceLayout.getCardHeight(context, true) * 0.6,
        child: thumbnail,
      ),
      content,
    ];

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: DeviceLayout.getCardWidth(context),
        minHeight: DeviceLayout.getInlineContentHeight(context),
      ),
      child: Column(
        children: thumbnailOnTop ? children : children.reversed.toList(),
      ),
    );
  }

  @override
  Widget buildTabletLayout(BuildContext context) {
    final children = [
      SizedBox(
        width: double.infinity,
        height: DeviceLayout.getCardHeight(context, true) * 0.7,
        child: thumbnail,
      ),
      Expanded(child: content),
    ];

    return SizedBox(
      width: DeviceLayout.getCardWidth(context),
      height: DeviceLayout.getInlineContentHeight(context),
      child: Column(
        children: thumbnailOnTop ? children : children.reversed.toList(),
      ),
    );
  }
}
