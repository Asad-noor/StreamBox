import 'package:flutter_test/flutter_test.dart';

import '../../../../support/content_fixtures.dart';

void main() {
  group('ContentDetails for a movie', () {
    test('has no seasons', () {
      expect(buildMovieDetails().hasSeasons, isFalse);
      expect(buildMovieDetails().seasons, isEmpty);
    });

    test('plays its own stream', () {
      final details = buildMovieDetails(
        content: buildContent(streamUrl: 'https://example.invalid/m.m3u8'),
      );

      expect(details.primaryStreamUrl, 'https://example.invalid/m.m3u8');
      expect(details.isPlayable, isTrue);
      expect(details.firstEpisode, isNull);
    });

    test('is not playable without a stream', () {
      expect(
        buildMovieDetails(content: buildContent(streamUrl: null)).isPlayable,
        isFalse,
      );
    });

    test('labels its length as a runtime', () {
      final details = buildMovieDetails(
        content: buildContent(duration: const Duration(minutes: 112)),
      );

      expect(details.lengthLabel, '1h 52m');
    });
  });

  group('ContentDetails for a series', () {
    test('starts on the first episode of the first season', () {
      final details = buildSeriesDetails();

      expect(details.firstEpisode?.id, 's1e1');
      expect(details.primaryStreamUrl, details.firstEpisode?.streamUrl);
      expect(details.isPlayable, isTrue);
    });

    test('skips a leading season that has no episodes', () {
      final details = buildSeriesDetails(
        seasons: [
          buildSeason(number: 1, episodes: []),
          buildSeason(number: 2),
        ],
      );

      expect(details.firstEpisode?.id, 's2e1');
    });

    test('skips a leading episode that has no stream', () {
      final details = buildSeriesDetails(
        seasons: [
          buildSeason(
            number: 1,
            episodes: [buildEpisode(id: 'unplayable', streamUrl: null)],
          ),
          buildSeason(number: 2),
        ],
      );

      expect(details.primaryStreamUrl, isNotNull);
    });

    test('is not playable when no episode has a stream', () {
      final details = buildSeriesDetails(
        seasons: [
          buildSeason(number: 1, episodes: [buildEpisode(streamUrl: null)]),
        ],
      );

      expect(details.isPlayable, isFalse);
      expect(details.primaryStreamUrl, isNull);
    });

    test('is not playable with no seasons at all', () {
      final details = buildSeriesDetails(seasons: []);

      expect(details.isPlayable, isFalse);
      expect(details.firstEpisode, isNull);
    });

    test('labels its length by season count', () {
      expect(buildSeriesDetails(seasonCount: 3).lengthLabel, '3 seasons');
      expect(
        buildSeriesDetails(seasons: [buildSeason()]).lengthLabel,
        '1 season',
      );
    });
  });

  group('Season and Episode', () {
    test('season reports its episode count and emptiness', () {
      expect(buildSeason(episodeCount: 4).episodeCount, 4);
      expect(buildSeason(episodes: []).isEmpty, isTrue);
      expect(buildSeason(episodes: []).firstEpisode, isNull);
    });

    test('episode formats its duration', () {
      expect(
        buildEpisode(duration: const Duration(minutes: 47)).formattedDuration,
        '47m',
      );
      expect(
        buildEpisode(duration: const Duration(minutes: 62)).formattedDuration,
        '1h 2m',
      );
    });

    test('episode playability follows its stream URL', () {
      expect(buildEpisode().isPlayable, isTrue);
      expect(buildEpisode(streamUrl: null).isPlayable, isFalse);
      expect(buildEpisode(streamUrl: '').isPlayable, isFalse);
    });
  });
}
