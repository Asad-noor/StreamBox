import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_spacing.dart';

/// The search input.
///
/// Owns its [TextEditingController] because that is genuinely widget state:
/// the notifier holds the settled query, not the per-keystroke text.
class SearchField extends StatefulWidget {
  const SearchField({
    required this.onChanged,
    this.initialValue = '',
    this.autofocus = false,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final String initialValue;
  final bool autofocus;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageGutter,
        vertical: AppSpacing.xs,
      ),
      child: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, value, _) => TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          textInputAction: TextInputAction.search,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'Search films and series',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Clear search',
                    onPressed: _clear,
                  ),
          ),
        ),
      ),
    );
  }
}
