sealed class ContentSegment {}

class HtmlSegment extends ContentSegment {
  const HtmlSegment(this.html);
  final String html;
}

class CodeSegment extends ContentSegment {
  const CodeSegment({required this.attrs, required this.code});

  /// Full attribute string from the opening `<code>` tag (e.g. ` class="language-dart"`).
  final String attrs;

  /// HTML-encoded code content (newlines encoded as `&#10;` by post_service).
  final String code;
}

/// Splits an HTML string into alternating [HtmlSegment] and [CodeSegment] parts
/// by locating every `<pre><code ...>...</code></pre>` block.
List<ContentSegment> splitHtmlContent(String html) {
  final segments = <ContentSegment>[];
  final pattern = RegExp(r'<pre><code([^>]*)>([\s\S]*?)</code></pre>');
  var lastEnd = 0;

  for (final match in pattern.allMatches(html)) {
    if (match.start > lastEnd) {
      segments.add(HtmlSegment(html.substring(lastEnd, match.start)));
    }
    segments.add(CodeSegment(attrs: match.group(1)!, code: match.group(2)!));
    lastEnd = match.end;
  }

  if (lastEnd < html.length) {
    segments.add(HtmlSegment(html.substring(lastEnd)));
  }

  return segments;
}
