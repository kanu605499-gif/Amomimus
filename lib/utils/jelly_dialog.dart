import 'package:flutter/material.dart';

/// Displays a dialog with a smooth, jelly-like elastic popup animation.
/// Uses [showGeneralDialog] under the hood to customize the transition.
Future<T?> showJellyDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black54,
    barrierLabel:
        barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder:
        (
          BuildContext buildContext,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          final Widget pageChild = Builder(builder: builder);
          return SafeArea(
            top: useSafeArea,
            bottom: useSafeArea,
            left: useSafeArea,
            right: useSafeArea,
            child: pageChild,
          );
        },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // ElasticOut for pop-in (jelly effect), EaseInBack for pop-out
      final isForward =
          animation.status == AnimationStatus.forward ||
          animation.status == AnimationStatus.completed;
      final curve = isForward ? Curves.elasticOut : Curves.easeInBack;

      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: curve)),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: isForward ? Curves.easeOut : Curves.easeIn,
            ),
          ),
          child: child,
        ),
      );
    },
  );
}
