import 'package:flutter/material.dart';

class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  double get screenHeight => MediaQuery.of(context).size.height;
  double get screenWidth => MediaQuery.of(context).size.width;

  double get shortestSide => MediaQuery.of(context).size.shortestSide;

  static const double smallScreenHeight = 700;
  static const double largeScreenHeight = 900;
  static const double narrowScreenWidth = 380;
  static const double tabletBreakpoint = 600;

  bool get isTablet => shortestSide >= tabletBreakpoint;
  bool get isPhone => !isTablet;

  bool get isSmallScreen => screenHeight < smallScreenHeight;
  bool get isLargeScreen => screenHeight > largeScreenHeight;
  bool get isNarrowScreen => screenWidth < narrowScreenWidth;

  double get horizontalPadding => isNarrowScreen ? 16.0 : 20.0;
  double get horizontalPaddingLarge => isNarrowScreen ? 16.0 : 24.0;

  double spacing({
    required double small,
    required double medium,
    required double large,
  }) {
    if (isSmallScreen) return small;
    if (isLargeScreen) return large;
    return medium;
  }

  double fontSize({
    required double small,
    required double medium,
    required double large,
  }) {
    if (isSmallScreen) return small;
    if (isLargeScreen) return large;
    return medium;
  }

  double ratio({
    required double small,
    required double medium,
    required double large,
  }) {
    if (isSmallScreen) return small;
    if (isLargeScreen) return large;
    return medium;
  }

  double spacingByDevice({required double phone, required double tablet}) {
    return isTablet ? tablet : phone;
  }

  double fontSizeByDevice({required double phone, required double tablet}) {
    return isTablet ? tablet : phone;
  }

  static ResponsiveUtils of(BuildContext context) => ResponsiveUtils(context);
}

/// Extension on BuildContext for easy access
extension ResponsiveExtension on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
}
