// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:blog/components/about_section.dart' as _about_section;
import 'package:blog/components/blog_interactive_section.dart'
    as _blog_interactive_section;
import 'package:blog/components/blog_preview_card.dart' as _blog_preview_card;
import 'package:blog/components/blog_preview_section.dart'
    as _blog_preview_section;
import 'package:blog/components/blog_sidebar.dart' as _blog_sidebar;
import 'package:blog/components/contact_section.dart' as _contact_section;
import 'package:blog/components/copy_button.dart' as _copy_button;
import 'package:blog/components/featured_post_card.dart' as _featured_post_card;
import 'package:blog/components/header.dart' as _header;
import 'package:blog/components/hero_section.dart' as _hero_section;
import 'package:blog/components/package_card.dart' as _package_card;
import 'package:blog/components/packages_section.dart' as _packages_section;
import 'package:blog/components/post_list_row.dart' as _post_list_row;
import 'package:blog/components/site_footer.dart' as _site_footer;
import 'package:blog/components/stats_strip.dart' as _stats_strip;
import 'package:blog/components/table_of_contents.dart' as _table_of_contents;
import 'package:blog/constants/theme.dart' as _theme;
import 'package:blog/pages/blog/blog_list.dart' as _blog_list;
import 'package:blog/pages/blog/blog_post.dart' as _blog_post;
import 'package:blog/app.dart' as _app;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _blog_interactive_section.BlogInteractiveSection:
        ClientTarget<_blog_interactive_section.BlogInteractiveSection>(
          'blog_interactive_section',
          params: __blog_interactive_sectionBlogInteractiveSection,
        ),
    _copy_button.CopyButton: ClientTarget<_copy_button.CopyButton>(
      'copy_button',
      params: __copy_buttonCopyButton,
    ),
    _header.Header: ClientTarget<_header.Header>('header'),
    _package_card.PackageCard: ClientTarget<_package_card.PackageCard>(
      'package_card',
      params: __package_cardPackageCard,
    ),
  },
  styles: () => [
    ..._theme.globalStyles,
    ..._app.App.styles,
    ..._about_section.AboutSection.styles,
    ..._blog_interactive_section.BlogInteractiveSection.styles,
    ..._blog_preview_card.BlogPreviewCard.styles,
    ..._blog_preview_section.BlogPreviewSection.styles,
    ..._blog_sidebar.BlogSidebar.styles,
    ..._contact_section.ContactSection.styles,
    ..._copy_button.CopyButton.styles,
    ..._featured_post_card.FeaturedPostCard.styles,
    ..._header.Header.styles,
    ..._hero_section.HeroSection.styles,
    ..._package_card.PackageCard.styles,
    ..._packages_section.PackagesSection.styles,
    ..._post_list_row.PostListRow.styles,
    ..._site_footer.SiteFooter.styles,
    ..._stats_strip.StatsStrip.styles,
    ..._table_of_contents.TableOfContents.styles,
    ..._blog_list.BlogListPage.styles,
    ..._blog_post.BlogPostPage.styles,
  ],
);

Map<String, Object?> __blog_interactive_sectionBlogInteractiveSection(
  _blog_interactive_section.BlogInteractiveSection c,
) => {'posts': c.posts.map((i) => i.encode()).toList()};
Map<String, Object?> __copy_buttonCopyButton(_copy_button.CopyButton c) => {
  'codeBlockId': c.codeBlockId,
};
Map<String, Object?> __package_cardPackageCard(_package_card.PackageCard c) => {
  'name': c.name,
  'description': c.description,
  'initialVersion': c.initialVersion,
  'initialStars': c.initialStars,
  'pubDevUrl': c.pubDevUrl,
  'iconColor': c.iconColor,
};
