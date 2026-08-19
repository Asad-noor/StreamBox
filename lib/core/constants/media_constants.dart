/// External media endpoints, kept in one place so they are trivially swapped.
///
/// Every URL here is a public test stream published for exactly this purpose.
/// They are verified reachable and multi-variant; see
/// `test/core/constants/media_constants_test.dart`, and the network-tagged
/// test that checks they still resolve.
abstract final class MediaConstants {
  /// Apple's reference HLS stream. 24 variants, fMP4 segments.
  ///
  /// The default because it is the most stable public HLS endpoint there is
  /// and it exercises adaptive switching properly.
  static const String appleTestStream =
      'https://devstreaming-cdn.apple.com/videos/streaming/examples/'
      'img_bipbop_adv_example_fmp4/master.m3u8';

  /// Mux's public test asset. 5 variants.
  static const String muxTestStream =
      'https://stream.mux.com/v69RSHhFelSm4701snP22dYz2jICy4E4FUyk02rW4gxRM.m3u8';

  /// Mux's HLS conformance stream. 5 variants.
  static const String muxConformanceStream =
      'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';

  /// Every stream the catalogue draws from.
  static const List<String> testStreams = [
    appleTestStream,
    muxTestStream,
    muxConformanceStream,
  ];

  /// The stream a title plays.
  ///
  /// Spread across [testStreams] by identifier so that the catalogue does not
  /// look like every title is the same video, while staying deterministic.
  static String streamUrlFor(String seed) =>
      testStreams[seed.hashCode.abs() % testStreams.length];

  /// Deterministic placeholder artwork. A seed always returns the same image,
  /// so the fake catalogue looks identical on every run and in every test.
  static String posterUrl(String seed) =>
      'https://picsum.photos/seed/$seed/400/600';

  static String backdropUrl(String seed) =>
      'https://picsum.photos/seed/$seed/1280/720';
}
