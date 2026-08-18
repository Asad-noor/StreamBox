import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/database/app_database.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/favorites/data/repositories/drift_favorites_repository.dart';

import '../../../support/content_fixtures.dart';
import '../../../support/failing_database.dart';
import '../../../support/test_database.dart';

void main() {
  late AppDatabase database;
  late DriftFavoritesRepository repository;
  late DateTime clock;

  setUp(() {
    clock = DateTime(2026, 8, 19, 12);
    database = createTestDatabase();
    repository = DriftFavoritesRepository(database, now: () => clock);
  });

  group('DriftFavoritesRepository', () {
    test('starts empty', () async {
      expect((await repository.getFavoriteIds()).valueOrNull, isEmpty);
      expect(await repository.watchFavorites().first, isEmpty);
    });

    test('stores a display snapshot with the entry', () async {
      await repository.add(
        buildContent(id: 'a', title: 'Harbour Lights', releaseYear: 2025),
      );

      final entry = (await repository.watchFavorites().first).single;
      expect(entry.contentId, 'a');
      expect(entry.content.title, 'Harbour Lights');
      expect(entry.content.releaseYear, 2025);
      expect(entry.content.posterUrl, isNotEmpty);
      expect(entry.addedAt, clock);
    });

    test('removes an entry', () async {
      await repository.add(buildContent(id: 'a'));
      await repository.remove('a');

      expect((await repository.getFavoriteIds()).valueOrNull, isEmpty);
    });

    test('removing something absent is harmless', () async {
      final result = await repository.remove('missing');

      expect(result.isSuccess, isTrue);
    });

    test('adding the same title twice keeps one row', () async {
      await repository.add(buildContent(id: 'a', title: 'First'));
      clock = clock.add(const Duration(minutes: 5));
      await repository.add(buildContent(id: 'a', title: 'Renamed'));

      final entries = await repository.watchFavorites().first;
      expect(entries, hasLength(1));
      // The snapshot is refreshed on every write, so it cannot go stale for
      // titles the viewer actually interacts with.
      expect(entries.single.content.title, 'Renamed');
      expect(entries.single.addedAt, clock);
    });

    test('orders newest first', () async {
      await repository.add(buildContent(id: 'old'));
      clock = clock.add(const Duration(hours: 1));
      await repository.add(buildContent(id: 'new'));

      final entries = await repository.watchFavorites().first;
      expect(entries.map((entry) => entry.contentId), ['new', 'old']);
    });

    test('re-emits as the table changes', () async {
      final counts = repository.watchFavorites().map((rows) => rows.length);

      // Drift coalesces notifications, so the assertion is on the sequence of
      // states the screen observes, not on one emission per write.
      final expectation = expectLater(counts, emitsInOrder([0, 1, 2, 1]));

      await pumpEventQueue();
      await repository.add(buildContent(id: 'a'));
      await pumpEventQueue();
      await repository.add(buildContent(id: 'b'));
      await pumpEventQueue();
      await repository.remove('a');
      await pumpEventQueue();

      await expectation;
    });

    test('the id stream stays in step with the entry stream', () async {
      await repository.add(buildContent(id: 'a'));
      await repository.add(buildContent(id: 'b'));

      expect(await repository.watchFavoriteIds().first, {'a', 'b'});
    });
  });

  group('failure handling', () {
    test('translates a driver error into a CacheException', () async {
      final failing = DriftFavoritesRepository(createFailingDatabase());

      final result = await failing.add(buildContent(id: 'a'));

      // Nothing driver-specific may escape the data layer.
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<CacheException>());
      expect(result.errorOrNull?.cause, isNotNull);
    });

    test('translates a failed delete too', () async {
      final failing = DriftFavoritesRepository(createFailingDatabase());

      expect((await failing.remove('a')).errorOrNull, isA<CacheException>());
    });
  });
}
