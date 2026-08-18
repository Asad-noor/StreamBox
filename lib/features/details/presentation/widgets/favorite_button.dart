import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_durations.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/favorites/presentation/providers/favorites_providers.dart';

/// Saves or unsaves a title.
///
/// Takes the whole [Content] because saving stores a display snapshot with the
/// entry, which is what lets the favourites screen render offline.
///
/// The database stream updates as soon as the write commits, so the icon
/// follows without this widget holding its own copy of the state. A failed
/// write leaves the stream untouched — the icon simply does not change — and
/// the viewer is told rather than left guessing.
class FavoriteButton extends ConsumerStatefulWidget {
  const FavoriteButton({
    required this.content,
    this.showLabel = false,
    super.key,
  });

  final Content content;

  /// Renders as a labelled button rather than a bare icon.
  final bool showLabel;

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> {
  bool _busy = false;

  Future<void> _toggle() async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      await ref
          .read(favoritesControllerProvider.notifier)
          .toggle(widget.content);
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
    final isFavorite = ref.watch(isFavoriteProvider(widget.content.id));
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
      return IconButton(onPressed: _toggle, icon: icon, tooltip: label);
    }

    return OutlinedButton.icon(
      onPressed: _toggle,
      icon: icon,
      label: Text(isFavorite ? 'In my list' : 'My list'),
    );
  }
}
