
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobileView;
  final Widget? tabletView;

  const ResponsiveBuilder({super.key, required this.mobileView, this.tabletView});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.tabletBreakpoint && tabletView != null) {
          return tabletView!;
        }
        return mobileView;
      },
    );
  }
}