import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';

import '../../../../support/content_fixtures.dart';

void main() {
  group('Content', () {
    test('formats duration with and without an hour component', () {
      expect(
        buildContent(duration: const Duration(minutes: 112)).formattedDuration,
        '1h 52m',
      );
      expect(
        buildContent(duration: const Duration(minutes: 47)).formattedDuration,
        '47m',
      );
      expect(
        buildContent(duration: const Duration(minutes: 120)).formattedDuration,
        '2h 0m',
      );
    });

    test('formats rating to one decimal place', () {
      expect(buildContent(rating: 8).formattedRating, '8.0');
      expect(buildContent(rating: 7.45).formattedRating, '7.5');
    });

    test('is playable only with a non-empty stream URL', () {
      expect(buildContent().isPlayable, isTrue);
      expect(buildContent(streamUrl: null).isPlayable, isFalse);
      expect(buildContent(streamUrl: '').isPlayable, isFalse);
    });

    test('metadata lists year, first genre and duration', () {
      final content = buildContent(
        releaseYear: 2024,
        genres: ['Thriller', 'Crime'],
        duration: const Duration(minutes: 94),
      );

      expect(content.metadata, ['2024', 'Thriller', '1h 34m']);
    });

    test('metadata omits genre when there is none', () {
      expect(buildContent(genres: []).metadata, hasLength(2));
    });

    test('identifies series', () {
      expect(buildContent(type: ContentType.series).isSeries, isTrue);
      expect(buildContent(type: ContentType.movie).isSeries, isFalse);
    });

    test('compares by value', () {
      expect(buildContent(id: 'a'), buildContent(id: 'a'));
      expect(buildContent(id: 'a'), isNot(buildContent(id: 'b')));
    });
  });

  group('HomeFeed', () {
    test('hides sections that have no items', () {
      final feed = buildHomeFeed(
        sections: [
          buildSection(title: 'Full'),
          buildSection(title: 'Empty', items: []),
        ],
      );

      expect(feed.visibleSections.map((section) => section.title), ['Full']);
    });

    test('is empty only when there is no featured title and no section', () {
      expect(buildHomeFeed().isEmpty, isFalse);
      expect(const HomeFeed(featured: null, sections: []).isEmpty, isTrue);
      expect(
        HomeFeed(featured: null, sections: [buildSection(items: [])]).isEmpty,
        isTrue,
      );
    });

    test('is not empty when only a featured title exists', () {
      expect(
        HomeFeed(featured: buildContent(), sections: const []).isEmpty,
        isFalse,
      );
    });
  });
}
