import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_spacing.dart';

/// The title bar above a content rail.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.onSeeAll,
    this.seeAllLabel = 'See all',
    super.key,
  });

  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              // A section title is a structural landmark, not decoration.
              semanticsLabel: title,
            ),
          ),
          if (onSeeAll case final onSeeAll?)
            TextButton(
              onPressed: onSeeAll,
              child: Semantics(
                label: '$seeAllLabel $title',
                excludeSemantics: true,
                child: Text(seeAllLabel),
              ),
            ),
        ],
      ),
    );
  }
}
