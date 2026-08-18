import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/retry_policy.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/content/hero_banner.dart';
import 'package:streambox/core/widgets/states/app_empty_view.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/home/presentation/pages/home_page.dart';
import 'package:streambox/features/home/presentation/widgets/home_feed_skeleton.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';

void main() {
  late FakeContentRepository repository;

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = ProviderContainer(
      retry: noAutomaticRetry,
      overrides: [contentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.dark, home: const HomePage()),
      ),
    );
  }

  setUp(() {
    repository = FakeContentRepository(feed: buildHomeFeed());
  });

  group('HomePage', () {
    testWidgets('shows the skeleton before data arrives', (tester) async {
      await pumpHome(tester);

      expect(find.byType(HomeFeedSkeleton), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('renders the hero and rails once loaded', (tester) async {
      repository.feed = buildHomeFeed(
        featured: buildContent(id: 'featured', title: 'The Long Descent'),
        sections: [
          buildSection(
            title: 'Trending now',
            items: [buildContent(id: 'a', title: 'Harbour Lights')],
          ),
        ],
      );

      await pumpHome(tester);
      await tester.pumpAndSettle();

      expect(find.byType(HomeFeedSkeleton), findsNothing);
      expect(find.byType(HeroBanner), findsOneWidget);
      expect(find.text('The Long Descent'), findsOneWidget);
      expect(find.text('Trending now'), findsOneWidget);
      expect(find.text('Harbour Lights'), findsOneWidget);
    });

    testWidgets('drops sections that have no items', (tester) async {
      repository.feed = buildHomeFeed(
        sections: [
          buildSection(title: 'Has items'),
          buildSection(title: 'Is empty', items: []),
        ],
      );

      await pumpHome(tester);
      await tester.pumpAndSettle();

      expect(find.text('Has items'), findsOneWidget);
      expect(find.text('Is empty'), findsNothing);
    });

    testWidgets('shows the error view and recovers on retry', (tester) async {
      repository.failure = const NetworkException();

      await pumpHome(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('You are offline'), findsOneWidget);

      repository.failure = null;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsNothing);
      expect(find.byType(HeroBanner), findsOneWidget);
    });

    testWidgets('shows the empty view for an empty catalogue', (tester) async {
      repository.feed = const HomeFeed(featured: null, sections: []);

      await pumpHome(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text('Nothing to watch yet'), findsOneWidget);
    });

    testWidgets('pull-to-refresh asks for fresh data', (tester) async {
      await pumpHome(tester);
      await tester.pumpAndSettle();

      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, 400),
        1000,
      );
      await tester.pumpAndSettle();

      expect(repository.forceRefreshCalls, contains(true));
    });

    testWidgets('labels series cards with their season count', (tester) async {
      repository.feed = buildHomeFeed(
        sections: [
          buildSection(
            items: [
              buildContent(
                id: 's',
                title: 'Harbour Lights',
                type: ContentType.series,
                seasonCount: 3,
              ),
            ],
          ),
        ],
      );

      await pumpHome(tester);
      await tester.pumpAndSettle();

      expect(find.text('3 seasons'), findsOneWidget);
    });

    testWidgets('builds rails lazily', (tester) async {
      repository.feed = buildHomeFeed(
        sections: [
          for (var index = 0; index < 12; index++)
            buildSection(title: 'Section $index'),
        ],
      );

      await pumpHome(tester);
      await tester.pumpAndSettle();

      // Off-screen rails must not be constructed.
      expect(find.text('Section 0'), findsOneWidget);
      expect(find.text('Section 11'), findsNothing);
      expect(tester.widgetList(find.byType(ContentCard)).length, lessThan(24));
    });
  });
}
