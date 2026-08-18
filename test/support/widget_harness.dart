import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';

/// Pumps [child] inside the real application theme.
///
/// Widget tests assert against the same `ThemeData` the app ships, so a token
/// change that breaks contrast or sizing shows up here rather than in review.
extension WidgetHarness on WidgetTester {
  Future<void> pumpInApp(
    Widget child, {
    List<Override> overrides = const [],
    Size surfaceSize = const Size(400, 800),
  }) async {
    await binding.setSurfaceSize(surfaceSize);
    addTearDown(() => binding.setSurfaceSize(null));

    await pumpWidget(
      AppProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(body: child),
        ),
      ),
    );
  }
}
