import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/layout/breakpoints.dart';

void main() {
  group('LayoutSize.fromWidth', () {
    test('classifies each range', () {
      expect(LayoutSize.fromWidth(320), LayoutSize.compact);
      expect(LayoutSize.fromWidth(599), LayoutSize.compact);
      expect(LayoutSize.fromWidth(600), LayoutSize.medium);
      expect(LayoutSize.fromWidth(899), LayoutSize.medium);
      expect(LayoutSize.fromWidth(900), LayoutSize.expanded);
      expect(LayoutSize.fromWidth(1440), LayoutSize.expanded);
    });

    test('treats a zero width as compact rather than failing', () {
      expect(LayoutSize.fromWidth(0), LayoutSize.compact);
    });
  });

  group('Breakpoints', () {
    test('card width grows with the layout class', () {
      final widths = LayoutSize.values.map(Breakpoints.cardWidth).toList();

      expect(widths, orderedEquals([...widths]..sort()));
      expect(widths.toSet(), hasLength(LayoutSize.values.length));
    });

    test('gutter grows with the layout class', () {
      final gutters = LayoutSize.values.map(Breakpoints.gutter).toList();

      expect(gutters, orderedEquals([...gutters]..sort()));
    });
  });
}
