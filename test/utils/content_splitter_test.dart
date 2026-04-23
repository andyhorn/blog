import 'package:flutter_test/flutter_test.dart';

import 'package:blog/utils/content_splitter.dart';

void main() {
  group('splitHtmlContent', () {
    test('returns single HtmlSegment when no code blocks present', () {
      const html = '<p>Hello</p><p>World</p>';
      final segments = splitHtmlContent(html);
      expect(segments, hasLength(1));
      expect(segments.first, isA<HtmlSegment>());
      expect((segments.first as HtmlSegment).html, html);
    });

    test('splits a single code block into three segments', () {
      const html = '<p>Before</p><pre><code>print("hi");</code></pre><p>After</p>';
      final segments = splitHtmlContent(html);
      expect(segments, hasLength(3));
      expect(segments[0], isA<HtmlSegment>());
      expect(segments[1], isA<CodeSegment>());
      expect(segments[2], isA<HtmlSegment>());
    });

    test('captures code block content correctly', () {
      const html = '<pre><code>let x = 1;</code></pre>';
      final segments = splitHtmlContent(html);
      expect(segments, hasLength(1));
      final code = segments.first as CodeSegment;
      expect(code.code, 'let x = 1;');
      expect(code.attrs, '');
    });

    test('captures language class attribute', () {
      const html = '<pre><code class="language-dart">void main() {}</code></pre>';
      final segments = splitHtmlContent(html);
      final code = segments.first as CodeSegment;
      expect(code.attrs, ' class="language-dart"');
    });

    test('handles html-encoded newlines (&#10;) in code content', () {
      const html = '<pre><code>line1&#10;line2&#10;line3</code></pre>';
      final segments = splitHtmlContent(html);
      final code = segments.first as CodeSegment;
      expect(code.code, 'line1&#10;line2&#10;line3');
    });

    test('handles multiple code blocks', () {
      const html = '<pre><code>first</code></pre><p>mid</p><pre><code>second</code></pre>';
      final segments = splitHtmlContent(html);
      expect(segments, hasLength(3));
      expect((segments[0] as CodeSegment).code, 'first');
      expect((segments[1] as HtmlSegment).html, '<p>mid</p>');
      expect((segments[2] as CodeSegment).code, 'second');
    });

    test('returns empty list for empty input', () {
      expect(splitHtmlContent(''), isEmpty);
    });

    test('leading html before first code block is captured', () {
      const html = '<h1>Title</h1><pre><code>code here</code></pre>';
      final segments = splitHtmlContent(html);
      expect(segments, hasLength(2));
      expect((segments[0] as HtmlSegment).html, '<h1>Title</h1>');
      expect((segments[1] as CodeSegment).code, 'code here');
    });
  });
}
