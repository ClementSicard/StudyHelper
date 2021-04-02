import 'package:flutter/material.dart';
import 'package:slide_popup_dialog/slide_dialog.dart';

Future<T> showCardPopup<T>({
  @required BuildContext context,
  @required Widget child,
  Color barrierColor,
  bool barrierDismissible = true,
  Duration transitionDuration = const Duration(milliseconds: 300),
  Color pillColor,
  Color backgroundColor,
}) {
  assert(context != null);
  assert(child != null);

  return showGeneralDialog(
    context: context,
    pageBuilder: (context, animation1, animation2) {},
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.7),
    barrierDismissible: barrierDismissible,
    barrierLabel: "Dismiss",
    transitionDuration: transitionDuration,
    transitionBuilder: (context, animation1, animation2, widget) {
      final curvedValue = Curves.easeInOut.transform(animation1.value) - 1.0;
      return StatefulBuilder(
        builder: (context, setStater) => Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -300, 0.0),
          child: Opacity(
            opacity: animation1.value,
            child: SlideDialog(
              child: child,
              pillColor: pillColor ?? Colors.blueGrey[200],
              backgroundColor: backgroundColor ?? Theme.of(context).canvasColor,
            ),
          ),
        ),
      );
    },
  );
}
