/// A heading extracted from post HTML content.
typedef TocItem = ({String text, String id});

/// Injects `id` attributes into `<h2>` tags in [html] that don't already have one.
///
/// Returns the modified HTML string. Call this after [_fixCodeBlockNewlines]
/// in post_service so code block content is already inert.
String injectHeadingIds(String html) {
  return html.replaceAllMapped(
    RegExp(r'<h2([^>]*)>(.*?)</h2>', dotAll: true),
    (match) {
      final existingAttrs = match.group(1)!;
      final inner = match.group(2)!;

      // Already has an id — leave untouched.
      if (RegExp(r'\bid=').hasMatch(existingAttrs)) {
        return match.group(0)!;
      }

      final text = inner.replaceAll(RegExp(r'<[^>]+>'), '');
      final id = _slugify(text);
      return '<h2 id="$id"$existingAttrs>$inner</h2>';
    },
  );
}

/// Extracts h2 headings from [html] (which should already have `id` attrs
/// injected by [injectHeadingIds]) and returns them as [TocItem] records.
List<TocItem> extractTocItems(String html) {
  final items = <TocItem>[];
  final pattern = RegExp(r'<h2[^>]+id="([^"]+)"[^>]*>(.*?)</h2>', dotAll: true);
  for (final match in pattern.allMatches(html)) {
    final id = match.group(1)!;
    final inner = match.group(2)!;
    final text = inner.replaceAll(RegExp(r'<[^>]+>'), '');
    items.add((id: id, text: text));
  }
  return items;
}

String _slugify(String text) => text
    .toLowerCase()
    .replaceAll(RegExp(r'[^\w\s-]'), '')
    .replaceAll(RegExp(r'[\s_]+'), '-')
    .replaceAll(RegExp(r'-{2,}'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');
