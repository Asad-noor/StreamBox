/// External media endpoints, kept in one place so they are trivially swapped.
abstract final class MediaConstants {
  /// Public HLS test stream published by Mux for exactly this purpose.
  ///
  /// Multi-bitrate, so it exercises adaptive switching and quality selection
  /// rather than only proving that a video decodes.
  static const String sampleHlsStream =
      'https://stream.mux.com/VZtzUzGRv02OhRnZCxcNg49OilvolTqdnFLEqBsd9wPI.m3u8';

  /// Deterministic placeholder artwork. A seed always returns the same image,
  /// so the fake catalogue looks identical on every run and in every test.
  static String posterUrl(String seed) =>
      'https://picsum.photos/seed/$seed/400/600';

  static String backdropUrl(String seed) =>
      'https://picsum.photos/seed/$seed/1280/720';
}
