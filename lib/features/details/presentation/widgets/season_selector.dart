import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/features/catalog/domain/entities/season.dart';

/// Chooses which season's episodes are listed.
///
/// A dropdown rather than a tab bar: series can have many seasons, and tabs
/// stop working long before the list does.
class SeasonSelector extends StatelessWidget {
  const SeasonSelector({
    required this.seasons,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<Season> seasons;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (seasons.length < 2) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButton<int>(
          value: selectedIndex,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          onChanged: (index) {
            if (index != null) onSelected(index);
          },
          items: [
            for (final (index, season) in seasons.indexed)
              DropdownMenuItem(
                value: index,
                child: Text(
                  '${season.title} · ${season.episodeCount} episodes',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
