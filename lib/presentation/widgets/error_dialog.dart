import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';

class ErrorDialog {
  static void show(BuildContext context, String message, {Object? error}) {
    final isPathAccessException = error is PathAccessException;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.error),
        content: Text(message),
        actions: [
          if (isPathAccessException)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/settings');
              },
              child: Text(context.l10n.macOSPermissionErrorButton),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }
}
