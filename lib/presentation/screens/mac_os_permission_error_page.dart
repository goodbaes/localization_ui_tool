import 'package:flutter/material.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';

class MacOSPermissionErrorPage extends StatelessWidget {
  const MacOSPermissionErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.macOSPermissionErrorTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.macOSPermissionErrorExplanation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              context.l10n.macOSPermissionErrorStepOne,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              context.l10n.macOSPermissionErrorStepTwo,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              context.l10n.macOSPermissionErrorStepThree,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              context.l10n.macOSPermissionErrorStepFour,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              context.l10n.macOSPermissionErrorStepFive,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              context.l10n.macOSPermissionErrorStepSix,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              context.l10n.macOSPermissionErrorStepSeven,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              context.l10n.macOSPermissionErrorStepEight,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
