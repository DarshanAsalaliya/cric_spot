import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';

Future<void> cricBottomSheet(BuildContext context, Widget child) async {
  return showModalBottomSheet(
    context: context,
    builder: (_) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SafeArea(
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: child,
        ),
      ),
    ),
  );
}

Future<void> cricAlertDialog(
  BuildContext context, {
  required Widget child,
  required Widget title,
  Widget? cancelButton,
  required Widget? confirmationButton,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      titleTextStyle: context.titleLarge,
      title: title,
      content: child,
      actions: [
        cancelButton ??
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
        if (confirmationButton != null) confirmationButton,
      ],
    ),
  );
}
