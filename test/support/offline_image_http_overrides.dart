import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

/// Serves a 1x1 transparent PNG for every request.
///
/// Widget tests must not touch the network: real requests are slow, depend on
/// the machine, and leave the image cache's retry timers pending when a test
/// navigates away mid-fetch — which fails the test with "A Timer is still
/// pending". Installing this makes image loading synchronous and deterministic.
void useOfflineImages() {
  final previous = HttpOverrides.current;
  HttpOverrides.global = _OfflineImageHttpOverrides();
  addTearDown(() => HttpOverrides.global = previous);
}

/// The smallest valid PNG: 1x1, fully transparent.
final Uint8List _transparentPng = Uint8List.fromList(const [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class _OfflineImageHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _OfflineHttpClient();
}

class _OfflineHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  String? userAgent;

  @override
  Duration? connectionTimeout;

  @override
  int? maxConnectionsPerHost;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _OfflineRequest(url);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _OfflineRequest(url);

  @override
  void close({bool force = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _OfflineRequest implements HttpClientRequest {
  _OfflineRequest(this.uri);

  @override
  final Uri uri;

  @override
  final HttpHeaders headers = _OfflineHeaders();

  @override
  Future<HttpClientResponse> close() async => _OfflineResponse();

  @override
  Future<HttpClientResponse> get done async => _OfflineResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _OfflineResponse implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  final HttpHeaders headers = _OfflineHeaders();

  @override
  bool get isRedirect => false;

  @override
  List<RedirectInfo> get redirects => const [];

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => Stream<List<int>>.value(_transparentPng).listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _OfflineHeaders implements HttpHeaders {
  @override
  ContentType? contentType = ContentType('image', 'png');

  @override
  int contentLength = -1;

  @override
  List<String>? operator [](String name) => null;

  @override
  String? value(String name) => null;

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void forEach(void Function(String name, List<String> values) action) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
