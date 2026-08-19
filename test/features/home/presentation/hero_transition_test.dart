import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/widgets/content/content_card.dart';
import 'package:streambox/core/widgets/content/content_rail.dart';
import 'package:streambox/features/catalog/domain/entities/content_section.dart';
import 'package:streambox/features/home/presentation/widgets/home_feed_view.dart';

import '../../../support/content_fixtures.dart';
import '../../../support/offline_image_http_overrides.dart';
import '../../../support/widget_harness.dart';

void main() {
  group('shared poster transition', () {
    testWidgets('exactly one rail claims each title', (tester) async {
      useOfflineImages();

      // The same title appears in three rails, which is normal for a feed.
      final content = buildContent(id: 'shared', title: 'Harbour Lights');
      final feed = buildHomeFeed(
        featured: content,
        sections: [
          buildSection(
            kind: ContentSectionKind.trending,
            title: 'Trending now',
            items: [content],
          ),
          buildSection(
            kind: ContentSectionKind.popular,
            title: 'Popular',
            items: [content],
          ),
          buildSection(
            kind: ContentSectionKind.newReleases,
            title: 'New releases',
            items: [content],
          ),
        ],
      );

      await tester.pumpInApp(
        HomeFeedView(feed: feed, onContentTap: (_) {}, onWatch: (_) {}),
        surfaceSize: const Size(400, 2400),
      );
      await tester.pumpAndSettle();

      final tagged = tester
          .widgetList<ContentCard>(find.byType(ContentCard))
          .where((card) => card.heroId != null);

      // Duplicate hero tags on one route throw at runtime, so only one rail
      // may opt in.
      expect(tagged, hasLength(1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a card without a hero id renders no Hero', (tester) async {
      await tester.pumpInApp(
        const ContentCard(title: 'Untagged'),
        surfaceSize: const Size(400, 800),
      );

      expect(find.byType(Hero), findsNothing);
    });

    testWidgets('a card with a hero id renders one', (tester) async {
      useOfflineImages();

      await tester.pumpInApp(
        const ContentCard(title: 'Tagged', heroId: 'abc'),
        surfaceSize: const Size(400, 800),
      );

      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, ContentCard.heroTag('abc'));
    });

    testWidgets('rails still render when nothing claims a hero', (
      tester,
    ) async {
      useOfflineImages();

      await tester.pumpInApp(
        ContentRail(
          title: 'Popular',
          itemCount: 3,
          itemBuilder: (context, index) => ContentCard(title: 'Title $index'),
        ),
        surfaceSize: const Size(400, 800),
      );

      expect(find.byType(ContentCard), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
