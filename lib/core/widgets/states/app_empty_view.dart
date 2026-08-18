import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_spacing.dart';

/// Shown when a request succeeded but returned nothing.
///
/// Distinct from [AppErrorView] on purpose: an empty favourites list is a
/// normal state that deserves an invitation, not an error icon.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAction = onAction != null && actionLabel != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            if (message case final message?) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (hasAction) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
