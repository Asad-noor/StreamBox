import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/features/catalog/data/models/content_model.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';

void main() {
  Map<String, dynamic> json({String type = 'movie'}) => {
    'id': 'the-long-descent',
    'title': 'The Long Descent',
    'type': type,
    'synopsis': 'A salvage crew wakes from cryosleep.',
    'poster_url': 'https://example.invalid/poster.jpg',
    'backdrop_url': 'https://example.invalid/backdrop.jpg',
    'release_year': 2026,
    'genres': ['Sci-fi', 'Thriller'],
    'rating': 8.4,
    'duration_minutes': 112,
    'stream_url': 'https://example.invalid/stream.m3u8',
    'season_count': null,
  };

  group('ContentModel', () {
    test('decodes the wire format', () {
      final model = ContentModel.fromJson(json());

      expect(model.id, 'the-long-descent');
      expect(model.releaseYear, 2026);
      expect(model.durationMinutes, 112);
      expect(model.genres, ['Sci-fi', 'Thriller']);
    });

    test('round-trips through JSON', () {
      final model = ContentModel.fromJson(json());

      expect(
        ContentModel.fromJson(model.toJson()).toEntity(),
        model.toEntity(),
      );
    });

    test('converts minutes into a Duration on the entity', () {
      expect(
        ContentModel.fromJson(json()).toEntity().duration,
        const Duration(minutes: 112),
      );
    });

    test('maps the type string onto the enum', () {
      expect(
        ContentModel.fromJson(json(type: 'series')).toEntity().type,
        ContentType.series,
      );
      expect(ContentModel.fromJson(json()).toEntity().type, ContentType.movie);
    });

    test('is case insensitive about the type', () {
      expect(
        ContentModel.fromJson(json(type: 'SERIES')).toEntity().type,
        ContentType.series,
      );
    });

    test('falls back to movie rather than failing on an unknown type', () {
      expect(
        ContentModel.fromJson(json(type: 'documentary')).toEntity().type,
        ContentType.movie,
      );
    });

    test('rejects a payload missing a required field', () {
      final incomplete = json()..remove('title');

      expect(() => ContentModel.fromJson(incomplete), throwsA(isA<Error>()));
    });
  });
}
