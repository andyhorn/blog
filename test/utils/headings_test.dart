import 'package:flutter_test/flutter_test.dart';

import 'package:blog/utils/headings.dart';

void main() {
  group('injectHeadingIds', () {
    test('injects id from heading text', () {
      final result = injectHeadingIds('<h2>Hello World</h2>');
      expect(result, '<h2 id="hello-world">Hello World</h2>');
    });

    test('slugifies text for the id', () {
      final result = injectHeadingIds('<h2>What Is Flutter?</h2>');
      expect(result, '<h2 id="what-is-flutter">What Is Flutter?</h2>');
    });

    test('strips inner HTML tags when building the id', () {
      final result = injectHeadingIds('<h2><strong>Bold</strong> Heading</h2>');
      expect(result, '<h2 id="bold-heading"><strong>Bold</strong> Heading</h2>');
    });

    test('preserves existing id attribute', () {
      const input = '<h2 id="already-set">Hello</h2>';
      expect(injectHeadingIds(input), input);
    });

    test('leaves other heading levels untouched', () {
      const input = '<h3>Not Touched</h3>';
      expect(injectHeadingIds(input), input);
    });

    test('handles multiple headings', () {
      final result = injectHeadingIds('<h2>First</h2><h2>Second</h2>');
      expect(result, '<h2 id="first">First</h2><h2 id="second">Second</h2>');
    });

    test('returns unchanged HTML when no h2 present', () {
      const input = '<p>Just a paragraph.</p>';
      expect(injectHeadingIds(input), input);
    });
  });

  group('extractTocItems', () {
    test('extracts id and text from h2 with injected id', () {
      const html = '<h2 id="intro">Introduction</h2>';
      final items = extractTocItems(html);
      expect(items, hasLength(1));
      expect(items.first.id, 'intro');
      expect(items.first.text, 'Introduction');
    });

    test('strips inner HTML from text', () {
      const html = '<h2 id="bold-heading"><strong>Bold</strong> Heading</h2>';
      final items = extractTocItems(html);
      expect(items.first.text, 'Bold Heading');
    });

    test('returns empty list when no h2 headings', () {
      expect(extractTocItems('<p>No headings here</p>'), isEmpty);
    });

    test('extracts multiple items in order', () {
      const html = '<h2 id="first">First</h2><h2 id="second">Second</h2>';
      final items = extractTocItems(html);
      expect(items.map((i) => i.id), ['first', 'second']);
      expect(items.map((i) => i.text), ['First', 'Second']);
    });

    test('round-trips with injectHeadingIds', () {
      const html = '<h2>Getting Started</h2><h2>Next Steps</h2>';
      final injected = injectHeadingIds(html);
      final items = extractTocItems(injected);
      expect(items.map((i) => i.id), ['getting-started', 'next-steps']);
      expect(items.map((i) => i.text), ['Getting Started', 'Next Steps']);
    });
  });
}
