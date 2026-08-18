import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/features/favorites/data/repositories/in_memory_favorites_repository.dart';

void main() {
  late InMemoryFavoritesRepository repository;

  setUp(() {
    repository = InMemoryFavoritesRepository();
    addTearDown(repository.dispose);
  });

  group('InMemoryFavoritesRepository', () {
    test('starts empty', () async {
      expect((await repository.getFavoriteIds()).valueOrNull, isEmpty);
    });

    test('accepts a starting set', () async {
      final seeded = InMemoryFavoritesRepository(initialIds: {'a', 'b'});
      addTearDown(seeded.dispose);

      expect((await seeded.getFavoriteIds()).valueOrNull, {'a', 'b'});
    });

    test('adds and removes', () async {
      await repository.add('a');
      expect((await repository.getFavoriteIds()).valueOrNull, {'a'});

      await repository.remove('a');
      expect((await repository.getFavoriteIds()).valueOrNull, isEmpty);
    });

    test('adding twice is idempotent', () async {
      await repository.add('a');
      await repository.add('a');

      expect((await repository.getFavoriteIds()).valueOrNull, {'a'});
    });

    test('removing something absent is harmless', () async {
      final result = await repository.remove('missing');

      expect(result.isSuccess, isTrue);
    });

    test('replays current state to a late subscriber', () async {
      await repository.add('a');

      expect(await repository.watchFavoriteIds().first, {'a'});
    });

    test('emits on every change', () async {
      final emissions = <Set<String>>[];
      final subscription = repository.watchFavoriteIds().listen(emissions.add);
      addTearDown(subscription.cancel);

      await repository.add('a');
      await repository.add('b');
      await repository.remove('a');
      await Future<void>.delayed(Duration.zero);

      expect(emissions, [
        <String>{},
        {'a'},
        {'a', 'b'},
        {'b'},
      ]);
    });

    test('does not emit when nothing changed', () async {
      final emissions = <Set<String>>[];
      final subscription = repository.watchFavoriteIds().listen(emissions.add);
      addTearDown(subscription.cancel);

      await repository.add('a');
      await repository.add('a');
      await repository.remove('zzz');
      await Future<void>.delayed(Duration.zero);

      expect(emissions, hasLength(2));
    });

    test('hands out an unmodifiable snapshot', () async {
      await repository.add('a');
      final ids = (await repository.getFavoriteIds()).valueOrNull!;

      expect(() => ids.add('b'), throwsUnsupportedError);
    });
  });
}
