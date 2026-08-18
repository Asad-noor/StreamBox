import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';

import '../../../support/widget_harness.dart';

void main() {
  group('AppErrorView', () {
    testWidgets('shows the exception message', (tester) async {
      await tester.pumpInApp(const AppErrorView(error: NetworkException()));

      expect(find.text(const NetworkException().message), findsOneWidget);
    });

    testWidgets('gives each failure kind its own headline', (tester) async {
      const cases = {
        NetworkException(): 'You are offline',
        RequestTimeoutException(): 'This is taking too long',
        UnauthorizedException(): 'Session expired',
        NotFoundException(): 'Nothing here',
        ServerException(statusCode: 500): 'Service unavailable',
      };

      for (final MapEntry(key: error, value: title) in cases.entries) {
        await tester.pumpInApp(AppErrorView(error: error));

        expect(
          find.text(title),
          findsOneWidget,
          reason: '${error.runtimeType} should be titled "$title"',
        );
      }
    });

    testWidgets('offers retry for recoverable failures', (tester) async {
      var retries = 0;

      await tester.pumpInApp(
        AppErrorView(error: const NetworkException(), onRetry: () => retries++),
      );

      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(retries, 1);
    });

    testWidgets('hides retry when retrying cannot help', (tester) async {
      for (final error in const [
        UnauthorizedException(),
        NotFoundException(),
      ]) {
        await tester.pumpInApp(AppErrorView(error: error, onRetry: () {}));

        expect(
          find.text('Try again'),
          findsNothing,
          reason: '${error.runtimeType} is not recoverable by retrying',
        );
      }
    });

    testWidgets('hides retry when no callback is supplied', (tester) async {
      await tester.pumpInApp(const AppErrorView(error: NetworkException()));

      expect(find.byType(FilledButton), findsNothing);
    });
  });
}
