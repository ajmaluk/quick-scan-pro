import 'package:flutter/material.dart';

enum SharedAxisTransitionType { horizontal, vertical, scaled }

class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SharedAxisTransitionType transitionType;

  SharedAxisPageRoute({
    required this.page,
    this.transitionType = SharedAxisTransitionType.horizontal,
    super.settings,
  }) : super(
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 240),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            switch (transitionType) {
              case SharedAxisTransitionType.horizontal:
                final offsetTween = Tween<Offset>(
                  begin: const Offset(0.09, 0),
                  end: Offset.zero,
                );
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.4, end: 1).animate(curve),
                  child: SlideTransition(
                    position: offsetTween.animate(curve),
                    child: child,
                  ),
                );
              case SharedAxisTransitionType.vertical:
                final offsetTween = Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                );
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.35, end: 1).animate(curve),
                  child: SlideTransition(
                    position: offsetTween.animate(curve),
                    child: child,
                  ),
                );
              case SharedAxisTransitionType.scaled:
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.25, end: 1).animate(curve),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.94, end: 1).animate(curve),
                    child: child,
                  ),
                );
            }
          },
        );
}

Future<T?> pushSharedAxis<T>(
  BuildContext context,
  Widget page, {
  SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
}) {
  return Navigator.of(context).push<T>(
    SharedAxisPageRoute<T>(
      page: page,
      transitionType: type,
    ),
  );
}

Future<T?> pushReplacementSharedAxis<T, TO>(
  BuildContext context,
  Widget page, {
  SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
}) {
  return Navigator.of(context).pushReplacement<T, TO>(
    SharedAxisPageRoute<T>(
      page: page,
      transitionType: type,
    ),
  );
}
