import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/database/app_database.dart';
import 'package:streambox/features/player/data/repositories/drift_playback_progress_repository.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';

import '../../../support/content_fixtures.dart';
import '../../../support/test_database.dart';

void main() {
  late AppDatabase database;
  late DriftPlaybackProgressRepository repository;

  PlaybackProgress progressFor(
    String id, {
    Duration position = const Duration(minutes: 3),
    Duration duration = const Duration(minutes: 10),
    DateTime? updatedAt,
  }) => PlaybackProgress(
    contentId: id,
    position: position,
    duration: duration,
    updatedAt: updatedAt ?? DateTime(2026, 8, 19, 12),
  );

  Future<void> save(
    String id, {
    Duration position = const Duration(minutes: 3),
    Duration duration = const Duration(minutes: 10),
    DateTime? updatedAt,
    String title = 'Test Title',
  }) => repository.saveProgress(
    content: buildSnapshot(contentId: id, title: title),
    progress: progressFor(
      id,
      position: position,
      duration: duration,
      updatedAt: updatedAt,
    ),
  );

  setUp(() {
    database = createTestDatabase();
    repository = DriftPlaybackProgressRepository(database);
  });

  group('resume points', () {
    test('returns null for a title never watched', () async {
      expect((await repository.getProgress('missing')).valueOrNull, isNull);
    });

    test('round-trips position and duration through milliseconds', () async {
      await save(
        'a',
        position: const Duration(minutes: 4, seconds: 37),
        duration: const Duration(minutes: 112),
      );

      final stored = (await repository.getProgress('a')).valueOrNull!;
      expect(stored.position, const Duration(minutes: 4, seconds: 37));
      expect(stored.duration, const Duration(minutes: 112));
    });

    test('updates in place rather than appending', () async {
      await save('a', position: const Duration(minutes: 1));
      await save('a', position: const Duration(minutes: 7));

      expect(await repository.watchHistory().first, hasLength(1));
      expect(
        (await repository.getProgress('a')).valueOrNull?.position,
        const Duration(minutes: 7),
      );
    });

    test('clearing removes only the named title', () async {
      await save('a');
      await save('b');

      await repository.clearProgress('a');

      final history = await repository.watchHistory().first;
      expect(history.map((entry) => entry.contentId), ['b']);
    });

    test('clearing everything empties history', () async {
      await save('a');
      await save('b');

      await repository.clearAll();

      expect(await repository.watchHistory().first, isEmpty);
    });
  });

  group('watch history', () {
    test('stores a display snapshot with each entry', () async {
      await save('a', title: 'Harbour Lights');

      final entry = (await repository.watchHistory().first).single;
      expect(entry.content.title, 'Harbour Lights');
      expect(entry.content.posterUrl, isNotEmpty);
    });

    test('orders most recently watched first', () async {
      await save('older', updatedAt: DateTime(2026, 8, 18));
      await save('newer', updatedAt: DateTime(2026, 8, 19));

      final history = await repository.watchHistory().first;
      expect(history.map((entry) => entry.contentId), ['newer', 'older']);
    });

    test('marks an entry resumable only when partly watched', () async {
      await save('started', position: const Duration(minutes: 3));
      await save('finished', position: const Duration(minutes: 10));
      await save('untouched', position: Duration.zero);

      final history = await repository.watchHistory().first;
      final resumable = history
          .where((entry) => entry.isResumable)
          .map((entry) => entry.contentId);

      expect(resumable, ['started']);
    });

    test('re-emits as the table changes', () async {
      final counts = repository.watchHistory().map((rows) => rows.length);

      final expectation = expectLater(counts, emitsInOrder([0, 1, 2, 1]));

      await pumpEventQueue();
      await save('a');
      await pumpEventQueue();
      await save('b');
      await pumpEventQueue();
      await repository.clearProgress('a');
      await pumpEventQueue();

      await expectation;
    });
  });
}
