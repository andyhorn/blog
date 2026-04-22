import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/blog_sidebar.dart';
import '../components/featured_post_card.dart';
import '../components/post_list_row.dart';
import '../constants/theme.dart';
import '../models/post.dart';

@client
class BlogInteractiveSection extends StatefulComponent {
  const BlogInteractiveSection({required this.posts, super.key});

  final List<Post> posts;

  @override
  State<BlogInteractiveSection> createState() => _BlogInteractiveSectionState();

  @css
  static List<StyleRule> get styles => [
    // Hero
    css('.blog-hero', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgSecondary,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(80),
          horizontal: Unit.pixels(120),
        ),
        raw: {'gap': '20px', 'border-bottom': '1px solid #1A1A1A'},
      ),
      css('.blog-hero__badge').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: accentPurple,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(4),
          horizontal: Unit.pixels(10),
        ),
        raw: {
          'background': '#A855F715',
          'border-radius': '4px',
          'display': 'inline-block',
          'align-self': 'flex-start',
        },
      ),
      css('.blog-hero__title').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(56),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(800),
        raw: {
          'line-height': '1.05',
          'letter-spacing': '-2px',
          'white-space': 'pre-line',
        },
      ),
      css('.blog-hero__sub').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(17),
        color: textMuted,
        margin: Spacing.zero,
        maxWidth: Unit.pixels(560),
        raw: {'line-height': '1.6'},
      ),
      css('.blog-hero__search').styles(
        display: .flex,
        alignItems: .center,
        maxWidth: Unit.pixels(560),
        raw: {
          'height': '52px',
          'background': '#111111',
          'border': '1px solid #2A2A2A',
          'border-radius': '8px',
          'gap': '12px',
          'padding': '0 20px',
        },
      ),
      css('.blog-hero__search-icon').styles(
        fontSize: Unit.pixels(18),
        color: textMuted,
      ),
      css('.blog-hero__search-input').styles(
        fontFamily: fontInter,
        fontSize: Unit.pixels(15),
        color: textPrimary,
        raw: {
          'background': 'transparent',
          'border': 'none',
          'outline': 'none',
          'flex': '1',
        },
      ),
      css('.blog-hero__search-input::placeholder').styles(
        raw: {'color': '#3A3A3A'},
      ),
    ]),
    // Filters
    css('.blog-filters', [
      css('&').styles(
        display: .flex,
        alignItems: .center,
        backgroundColor: bgSecondary,
        padding: Spacing.symmetric(horizontal: Unit.pixels(120)),
        raw: {
          'height': '56px',
          'gap': '12px',
          'border-top': '1px solid #1A1A1A',
          'border-bottom': '1px solid #1A1A1A',
        },
      ),
      css('.blog-filters__label').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
      ),
      css('.blog-filters__pill').styles(
        fontFamily: fontGeistMono,
        fontSize: Unit.pixels(12),
        color: textMuted,
        backgroundColor: borderDefault,
        raw: {
          'display': 'inline-flex',
          'align-items': 'center',
          'height': '30px',
          'padding': '0 14px',
          'border-radius': '9999px',
          'border': '1px solid #2A2A2A',
          'cursor': 'pointer',
        },
      ),
      css('.blog-filters__pill--active').styles(
        backgroundColor: accentPurple,
        color: bgBase,
        fontWeight: .w600,
        raw: {'border': 'none'},
      ),
    ]),
    // Body
    css('.blog-empty').styles(
      padding: Spacing.symmetric(
        vertical: Unit.pixels(64),
        horizontal: Unit.pixels(120),
      ),
    ),
    css('.blog-body', [
      css('&').styles(
        display: .flex,
        flexDirection: .row,
        backgroundColor: bgBase,
        padding: Spacing.symmetric(
          vertical: Unit.pixels(64),
          horizontal: Unit.pixels(120),
        ),
        raw: {'gap': '48px'},
      ),
      css('.blog-body__main').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'flex': '1', 'gap': '32px'},
      ),
      css('.blog-body__all-heading').styles(
        fontFamily: fontGeist,
        fontSize: Unit.pixels(22),
        fontWeight: .w700,
        color: textPrimary,
        margin: Spacing.zero,
      ),
      css('.blog-body__post-list').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: bgCard,
        radius: .all(.circular(8.px)),
        overflow: .clip,
        raw: {'border': '1px solid #1A1A1A', 'gap': '1px'},
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: breakpointMd.px), [
      css('.blog-hero').styles(
        padding: Spacing.symmetric(vertical: 48.px, horizontal: 24.px),
      ),
      css('.blog-hero__title').styles(
        raw: {'font-size': '36px', 'letter-spacing': '-1px'},
      ),
      css('.blog-hero__search').styles(
        maxWidth: 100.percent,
      ),
      css('.blog-filters').styles(
        padding: Spacing.symmetric(horizontal: 24.px),
        raw: {
          'height': 'auto',
          'padding-top': '12px',
          'padding-bottom': '12px',
          'flex-wrap': 'wrap',
          'row-gap': '8px',
        },
      ),
      css('.blog-body').styles(
        flexDirection: .column,
        padding: Spacing.symmetric(vertical: 40.px, horizontal: 24.px),
        raw: {'gap': '32px'},
      ),
      css('.blog-empty').styles(
        padding: Spacing.symmetric(vertical: 40.px, horizontal: 24.px),
      ),
    ]),
  ];
}

class _BlogInteractiveSectionState extends State<BlogInteractiveSection> {
  String _searchQuery = '';
  String _selectedTag = 'All';

  List<String> get _tags {
    final seen = <String>{};
    final result = ['All'];
    for (final post in component.posts) {
      for (final tag in post.meta.tags) {
        if (seen.add(tag)) result.add(tag);
      }
    }
    return result;
  }

  List<Post> get _filteredPosts {
    var filtered = component.posts;
    if (_selectedTag != 'All') {
      filtered = filtered.where((post) => post.meta.tags.contains(_selectedTag)).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (post) =>
                post.meta.title.toLowerCase().contains(q) ||
                post.meta.description.toLowerCase().contains(q) ||
                post.meta.tags.any((t) => t.toLowerCase().contains(q)),
          )
          .toList();
    }
    return filtered;
  }

  @override
  Component build(BuildContext context) {
    final tags = _tags;
    final filtered = _filteredPosts;
    final featured = filtered.isNotEmpty ? filtered.first : null;
    final rest = filtered.length > 1 ? filtered.skip(1).toList() : <Post>[];

    return div([
      // Hero
      div(classes: 'blog-hero', [
        span(classes: 'blog-hero__badge', [.text('// blog')]),
        h1(classes: 'blog-hero__title', [
          .text('Writing on Flutter,\nDart & Software Craft'),
        ]),
        p(classes: 'blog-hero__sub', [
          .text(
            'Thoughts on building apps, open-source packages, and the craft of software.',
          ),
        ]),
        div(classes: 'blog-hero__search', [
          span(classes: 'blog-hero__search-icon', [.text('🔍')]),
          input<String>(
            classes: 'blog-hero__search-input',
            attributes: {'type': 'text', 'placeholder': 'Search posts…'},
            onInput: (value) => setState(() => _searchQuery = value),
          ),
        ]),
      ]),
      // Tag filters
      div(classes: 'blog-filters', [
        span(classes: 'blog-filters__label', [.text('Filter:')]),
        for (final tag in tags)
          button(
            classes: 'blog-filters__pill${tag == _selectedTag ? ' blog-filters__pill--active' : ''}',
            onClick: () => setState(() => _selectedTag = tag),
            [.text(tag)],
          ),
      ]),
      // Body
      featured != null
          ? div(classes: 'blog-body', [
              div(classes: 'blog-body__main', [
                FeaturedPostCard(post: featured),
                if (rest.isNotEmpty) ...[
                  h2(classes: 'blog-body__all-heading', [.text('All Posts')]),
                  div(classes: 'blog-body__post-list', [
                    for (final post in rest) PostListRow(post: post),
                  ]),
                ],
              ]),
              const BlogSidebar(),
            ])
          : div(classes: 'blog-empty', [
              p([
                .text(
                  _searchQuery.isNotEmpty || _selectedTag != 'All'
                      ? 'No posts match your search.'
                      : 'No posts yet — check back soon.',
                ),
              ]),
            ]),
    ]);
  }
}
