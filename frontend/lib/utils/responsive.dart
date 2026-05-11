import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

class Responsive {
  static const double mobileBreak = 600;
  static const double tabletBreak = 1024;

  static ScreenSize of(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < mobileBreak) return ScreenSize.mobile;
    if (w < tabletBreak) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  static bool isMobile(BuildContext context)  => of(context) == ScreenSize.mobile;
  static bool isTablet(BuildContext context)   => of(context) == ScreenSize.tablet;
  static bool isDesktop(BuildContext context)  => of(context) == ScreenSize.desktop;

  static T value<T>(BuildContext context, {
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    switch (of(context)) {
      case ScreenSize.mobile:  return mobile;
      case ScreenSize.tablet:  return tablet;
      case ScreenSize.desktop: return desktop;
    }
  }
}