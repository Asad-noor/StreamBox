import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_spacing.dart';

/// Scaffolding for a screen whose real implementation lands in a later phase.
///
/// It exists so the navigation graph can be wired and tested end-to-end before
/// any feature has data behind it. Each usage is replaced by the real screen.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: theme.textTheme.headlineMedium),
              if (subtitle case final subtitle?) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
