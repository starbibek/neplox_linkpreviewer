import 'package:flutter/material.dart';

/// Utility class to determine device type and screen layout
class DeviceLayout {
  /// Check if device is a tablet based on shortest side
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    return shortestSide >= 600; // Standard tablet breakpoint
  }

  /// Get appropriate width based on device type and orientation
  static double getCardWidth(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = DeviceLayout.isTablet(context);

    if (isTablet) {
      return size.width * 0.7; // 70% width for tablets
    }
    return size.width * 0.95; // 95% width for phones
  }

  /// Get appropriate height based on device type and content
  static double getCardHeight(BuildContext context, bool hasImage) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = DeviceLayout.isTablet(context);

    if (isTablet) {
      return hasImage ? size.height * 0.35 : size.height * 0.2;
    }
    return hasImage ? size.height * 0.25 : size.height * 0.15;
  }

  /// Get appropriate height for the card content
  static double getInlineContentHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.height * 0.15;
  }
}
