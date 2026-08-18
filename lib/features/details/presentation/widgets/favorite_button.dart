import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_durations.dart';
import 'package:streambox/features/favorites/presentation/providers/favorites_providers.dart';

/// Saves or unsaves a title.
///
/// The repository stream updates within a frame, so the icon responds
/// immediately without this widget holding its own copy of the state. A failed
/// write leaves the stream untouched — the icon simply never changes — and the
/// failure is reported to the viewer rather than swallowed.
class FavoriteButton extends ConsumerStatefulWidget {
  const FavoriteButton({
    required this.contentId,
    this.showLabel = false,
    super.key,
  });

  final String contentId;

  /// Renders as a labelled button rather than a bare icon.
  final bool showLabel;

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> {
  bool _busy = false;

  Future<void> _toggle(bool isFavorite) async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      await ref
          .read(favoritesControllerProvider.notifier)
          .toggle(contentId: widget.contentId, isFavorite: isFavorite);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update your list.')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isFavoriteProvider(widget.contentId));
    final label = isFavorite ? 'Remove from my list' : 'Add to my list';

    final icon = AnimatedSwitcher(
      duration: AppDurations.fast,
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        isFavorite ? Icons.check_rounded : Icons.add_rounded,
        key: ValueKey(isFavorite),
        color: isFavorite ? AppColors.red : null,
      ),
    );

    if (!widget.showLabel) {
      return IconButton(
        onPressed: () => _toggle(isFavorite),
        icon: icon,
        tooltip: label,
      );
    }

    return OutlinedButton.icon(
      onPressed: () => _toggle(isFavorite),
      icon: icon,
      label: Text(isFavorite ? 'In my list' : 'My list'),
    );
  }
}
