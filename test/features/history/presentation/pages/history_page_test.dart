import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/features/history/presentation/pages/history_page.dart';
import 'package:streambox/features/history/presentation/widgets/history_tile.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';
import 'package:streambox/features/player/presentation/providers/player_providers.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/offline_image_http_overrides.dart';
import '../../../../support/recording_playback_progress_repository.dart';

void main() {
  late RecordingPlaybackProgressRepository repository;

  void seed(
    String id, {
    String title = 'Harbour Lights',
    Duration position = const Duration(minutes: 3),
    Duration duration = const Duration(minutes: 10),
    DateTime? updatedAt,
  }) => repository.seed(
    content: buildSnapshot(contentId: id, title: title),
    progress: PlaybackProgress(
      contentId: id,
      position: position,
      duration: duration,
      updatedAt: updatedAt ?? DateTime(2026, 8, 19, 12),
    ),
  );

  Future<void> pumpHistory(WidgetTester tester) async {
    useOfflineImages();
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppProviderScope(
        overrides: [
          playbackProgressRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(theme: AppTheme.dark, home: const HistoryPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    repository = RecordingPlaybackProgressRepository();
    addTearDown(repository.dispose);
  });

  group('HistoryPage', () {
    testWidgets('shows the empty state with nothing watched', (tester) async {
      await pumpHistory(tester);

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text('Nothing watched yet'), findsOneWidget);
      expect(find.text('Clear all'), findsNothing);
    });

    testWidgets('lists watched titles with their progress', (tester) async {
      seed('a', title: 'Harbour Lights', position: const Duration(minutes: 3));

      await pumpHistory(tester);

      expect(find.byType(HistoryTile), findsOneWidget);
      expect(find.text('Harbour Lights'), findsOneWidget);
      expect(find.text('3:00 of 10:00'), findsOneWidget);
    });

    testWidgets('marks a finished title as watched', (tester) async {
      seed('a', position: const Duration(minutes: 10));

      await pumpHistory(tester);

      expect(find.text('Watched'), findsOneWidget);
    });

    testWidgets('orders most recently watched first', (tester) async {
      seed('older', title: 'Older', updatedAt: DateTime(2026, 8, 18));
      seed('newer', title: 'Newer', updatedAt: DateTime(2026, 8, 19));

      await pumpHistory(tester);

      final titles = tester
          .widgetList<HistoryTile>(find.byType(HistoryTile))
          .map((tile) => tile.entry.content.title);

      expect(titles, ['Newer', 'Older']);
    });

    testWidgets('removes one entry', (tester) async {
      seed('a', title: 'Harbour Lights');

      await pumpHistory(tester);
      await tester.tap(find.byTooltip('Remove Harbour Lights from history'));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryTile), findsNothing);
    });

    testWidgets('clearing everything asks first and can be cancelled', (
      tester,
    ) async {
      seed('a');

      await pumpHistory(tester);
      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();

      expect(find.text('Clear watch history?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Irreversible actions must not fire on a stray tap.
      expect(find.byType(HistoryTile), findsOneWidget);
    });

    testWidgets('clearing everything empties the list once confirmed', (
      tester,
    ) async {
      seed('a');
      seed('b', title: 'Low Tide');

      await pumpHistory(tester);
      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryTile), findsNothing);
      expect(find.byType(AppEmptyView), findsOneWidget);
    });

    testWidgets('tells the viewer when a removal fails', (tester) async {
      seed('a', title: 'Harbour Lights');
      await pumpHistory(tester);

      repository.failure = const CacheException();
      await tester.tap(find.byTooltip('Remove Harbour Lights from history'));
      await tester.pumpAndSettle();

      expect(find.text('Could not update your history.'), findsOneWidget);
      expect(find.byType(HistoryTile), findsOneWidget);
    });
  });
}
