import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';
import 'package:streambox/core/widgets/states/async_value_view.dart';

import '../../../support/widget_harness.dart';

void main() {
  Widget viewOf(
    AsyncValue<List<String>> value, {
    Widget? skeleton,
    Widget? empty,
    VoidCallback? onRetry,
  }) => AsyncValueView<List<String>>(
    value: value,
    skeleton: skeleton,
    empty: empty,
    onRetry: onRetry,
    isEmpty: (items) => items.isEmpty,
    data: (items) => Text('${items.length} items'),
  );

  group('AsyncValueView', () {
    testWidgets('renders data', (tester) async {
      await tester.pumpInApp(viewOf(const AsyncValue.data(['a', 'b'])));

      expect(find.text('2 items'), findsOneWidget);
    });

    testWidgets('renders the supplied skeleton while loading', (tester) async {
      await tester.pumpInApp(
        viewOf(const AsyncValue.loading(), skeleton: const Text('skeleton')),
      );

      expect(find.text('skeleton'), findsOneWidget);
    });

    testWidgets('falls back to a spinner when no skeleton is given', (
      tester,
    ) async {
      await tester.pumpInApp(viewOf(const AsyncValue.loading()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders the error view with a retry action', (tester) async {
      var retries = 0;

      await tester.pumpInApp(
        viewOf(
          AsyncValue.error(const NetworkException(), StackTrace.empty),
          onRetry: () => retries++,
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(retries, 1);
    });

    testWidgets('wraps a non-AppException so the error view still renders', (
      tester,
    ) async {
      await tester.pumpInApp(
        viewOf(AsyncValue.error(StateError('raw'), StackTrace.empty)),
      );

      final view = tester.widget<AppErrorView>(find.byType(AppErrorView));

      expect(view.error, isA<UnknownException>());
      expect(view.error.cause, isA<StateError>());
    });

    testWidgets('shows the empty view for an empty payload', (tester) async {
      await tester.pumpInApp(
        viewOf(
          const AsyncValue.data([]),
          empty: const AppEmptyView(title: 'Nothing here'),
        ),
      );

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text('0 items'), findsNothing);
    });

    testWidgets('renders data when no empty view is supplied', (tester) async {
      await tester.pumpInApp(viewOf(const AsyncValue.data([])));

      expect(find.text('0 items'), findsOneWidget);
    });
  });
}
