import 'package:flutter/material.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/layout/breakpoints.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/content/content_rail.dart';
import 'package:streambox/core/widgets/content/hero_banner.dart';
import 'package:streambox/core/widgets/content/metadata_row.dart';
import 'package:streambox/core/widgets/skeleton/content_skeletons.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';

/// Every design-system component, in every state, on one scrollable page.
///
/// Reachable at `/dev/gallery` in development builds only. It exists so the
/// visual system can be reviewed and regression-tested without waiting for
/// feature data, and so a new contributor can see what already exists before
/// building something that duplicates it.
class DesignGalleryPage extends StatelessWidget {
  const DesignGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design system')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
        children: const [
          _Section(title: 'Hero banner', child: _HeroSample()),
          _Section(title: 'Colour', child: _ColourSample()),
          _Section(title: 'Typography', child: _TypographySample()),
          _Section(title: 'Buttons', child: _ButtonSample()),
          _Section(title: 'Metadata', child: _MetadataSample()),
          _Section(title: 'Cards', child: _CardSample()),
          _RailSample(),
          _Section(title: 'Loading', child: ContentRailSkeleton()),
          _Section(title: 'Empty', child: _EmptySample()),
          _Section(title: 'Errors', child: _ErrorSample()),
          _Section(title: 'Layout', child: _LayoutSample()),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xl),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
          ),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    ),
  );
}

class _HeroSample extends StatelessWidget {
  const _HeroSample();

  @override
  Widget build(BuildContext context) => const HeroBanner(
    title: 'The Long Descent',
    synopsis:
        'A salvage crew wakes from cryosleep to find their ship three '
        'hundred years off course and no longer alone aboard.',
    metadata: ['2026', 'TV-MA', '1h 52m', 'Sci-fi'],
  );
}

class _ColourSample extends StatelessWidget {
  const _ColourSample();

  static const Map<String, Color> _swatches = {
    'red': AppColors.red,
    'background': AppColors.background,
    'surface': AppColors.surface,
    'elevated': AppColors.surfaceElevated,
    'muted': AppColors.surfaceMuted,
    'border': AppColors.border,
    'error': AppColors.error,
    'success': AppColors.success,
  };

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
    child: Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final MapEntry(key: name, value: colour) in _swatches.entries)
          Column(
            children: [
              Container(
                width: 56,
                height: 40,
                decoration: BoxDecoration(
                  color: colour,
                  borderRadius: AppRadius.allSm,
                  border: Border.all(color: AppColors.border),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(name, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
      ],
    ),
  );
}

class _TypographySample extends StatelessWidget {
  const _TypographySample();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final samples = <String, TextStyle?>{
      'displayLarge': textTheme.displayLarge,
      'headlineMedium': textTheme.headlineMedium,
      'titleLarge': textTheme.titleLarge,
      'bodyLarge': textTheme.bodyLarge,
      'bodyMedium': textTheme.bodyMedium,
      'labelSmall': textTheme.labelSmall,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final MapEntry(key: name, value: style) in samples.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(name, style: style),
            ),
        ],
      ),
    );
  }
}

class _ButtonSample extends StatelessWidget {
  const _ButtonSample();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
    child: Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        FilledButton(onPressed: () {}, child: const Text('Watch')),
        OutlinedButton(onPressed: () {}, child: const Text('Details')),
        TextButton(onPressed: () {}, child: const Text('See all')),
        const FilledButton(onPressed: null, child: Text('Disabled')),
      ],
    ),
  );
}

class _MetadataSample extends StatelessWidget {
  const _MetadataSample();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
    child: MetadataRow(items: ['2026', 'TV-MA', '1h 52m', 'Thriller']),
  );
}

class _CardSample extends StatelessWidget {
  const _CardSample();

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        ContentCard(title: 'No artwork'),
        ContentCard(title: 'With subtitle', subtitle: 'Season 2'),
        ContentCard(title: 'Half watched', progress: 0.5),
        ContentCard(
          title: 'A very long title that has to wrap onto a second line',
        ),
        ContentCardSkeleton(),
      ],
    ),
  );
}

class _RailSample extends StatelessWidget {
  const _RailSample();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xl),
    child: ContentRail(
      title: 'Continue watching',
      itemCount: 8,
      onSeeAll: () {},
      itemBuilder: (context, index) => ContentCard(
        title: 'Title ${index + 1}',
        progress: (index + 1) / 10,
        onTap: () {},
      ),
    ),
  );
}

class _EmptySample extends StatelessWidget {
  const _EmptySample();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 260,
    child: AppEmptyView(
      title: 'No favourites yet',
      message: 'Titles you save will show up here.',
      icon: Icons.favorite_outline_rounded,
      actionLabel: 'Browse the catalogue',
      onAction: _noop,
    ),
  );

  static void _noop() {}
}

class _ErrorSample extends StatelessWidget {
  const _ErrorSample();

  static const List<AppException> _errors = [
    NetworkException(),
    RequestTimeoutException(),
    ServerException(statusCode: 503),
    UnauthorizedException(),
    NotFoundException(),
  ];

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final error in _errors)
        SizedBox(
          height: 300,
          child: AppErrorView(error: error, onRetry: _noop),
        ),
    ],
  );

  static void _noop() {}
}

/// Reports which layout class the current window falls into, so the
/// breakpoints can be checked by resizing rather than by reading the source.
class _LayoutSample extends StatelessWidget {
  const _LayoutSample();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final size = LayoutSize.fromWidth(constraints.maxWidth);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Breakpoints.gutter(size)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${constraints.maxWidth.round()}dp - ${size.name}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'card ${Breakpoints.cardWidth(size).round()}dp - '
              'gutter ${Breakpoints.gutter(size).round()}dp',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      );
    },
  );
}
