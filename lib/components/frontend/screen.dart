import 'package:flutter/material.dart';
import 'package:todo/components/constants/constants.dart';

class Screen {
  
  final BuildContext context;

  Screen(this.context);

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  Size get size => mediaQuery.size;

  double get width => size.width;
  double get height => size.height;
  double get customWidth => width / realmeWidth;
  double get topPadding => mediaQuery.viewPadding.top;
  double get bottomPadding => mediaQuery.viewPadding.bottom;

  bool get isMobile => customWidth <= 0.4;
  bool get isTablet => !isMobile && width < 1000;
  bool get isDesktop => !isMobile && !isTablet;
}
