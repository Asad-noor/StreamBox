import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Writes the screenshots taken by `integration_test/screenshot_test.dart`.
///
/// Run with:
/// `flutter drive --driver=test_driver/screenshot_driver.dart \
///    --target=integration_test/screenshot_test.dart -d DEVICE`
///
/// Regenerating every image is one command, so the README's screenshots can be
/// refreshed after a UI change instead of being re-taken by hand and quietly
/// drifting out of date.
Future<void> main() async {
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final file = File('docs/screenshots/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);

      return true;
    },
  );
}
