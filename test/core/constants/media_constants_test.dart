import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/constants/media_constants.dart';

void main() {
  group('MediaConstants', () {
    test('every stream is an https HLS playlist', () {
      for (final url in MediaConstants.testStreams) {
        final uri = Uri.parse(url);

        expect(uri.scheme, 'https', reason: url);
        expect(uri.host, isNotEmpty, reason: url);
        expect(uri.path, endsWith('.m3u8'), reason: url);
      }
    });

    test('streams are distinct', () {
      expect(
        MediaConstants.testStreams.toSet(),
        hasLength(MediaConstants.testStreams.length),
      );
    });

    test('a title always resolves to the same stream', () {
      expect(
        MediaConstants.streamUrlFor('harbour-lights'),
        MediaConstants.streamUrlFor('harbour-lights'),
      );
    });

    test('resolves only to a declared stream', () {
      for (final seed in [
        'a',
        'b',
        'c',
        'harbour-lights',
        'the-long-descent',
      ]) {
        expect(
          MediaConstants.testStreams,
          contains(MediaConstants.streamUrlFor(seed)),
          reason: seed,
        );
      }
    });

    test('spreads the catalogue across the available streams', () {
      final used = {
        for (var index = 0; index < 40; index++)
          MediaConstants.streamUrlFor('title-$index'),
      };

      // A catalogue where every title is the same video is a poor demo.
      expect(used, hasLength(MediaConstants.testStreams.length));
    });

    test('artwork URLs are deterministic per seed', () {
      expect(MediaConstants.posterUrl('a'), MediaConstants.posterUrl('a'));
      expect(
        MediaConstants.posterUrl('a'),
        isNot(MediaConstants.posterUrl('b')),
      );
    });
  });
}
