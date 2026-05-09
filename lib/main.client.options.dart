// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:blog/components/blog_interactive_section.dart'
    deferred as _blog_interactive_section;
import 'package:blog/components/copy_button.dart' deferred as _copy_button;
import 'package:blog/components/header.dart' deferred as _header;
import 'package:blog/components/package_card.dart' deferred as _package_card;
import 'package:blog/models/post.dart' as _post;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'blog_interactive_section': ClientLoader(
      (p) => _blog_interactive_section.BlogInteractiveSection(
        posts: (p['posts'] as List<Object?>)
            .map((i) => _post.Post.decode(i as Map<String, dynamic>))
            .toList(),
      ),
      loader: _blog_interactive_section.loadLibrary,
    ),
    'copy_button': ClientLoader(
      (p) => _copy_button.CopyButton(codeBlockId: p['codeBlockId'] as String),
      loader: _copy_button.loadLibrary,
    ),
    'header': ClientLoader(
      (p) => _header.Header(),
      loader: _header.loadLibrary,
    ),
    'package_card': ClientLoader(
      (p) => _package_card.PackageCard(
        name: p['name'] as String,
        description: p['description'] as String,
        initialVersion: p['initialVersion'] as String,
        initialStars: p['initialStars'] as int,
        pubDevUrl: p['pubDevUrl'] as String,
        iconColor: p['iconColor'] as String,
      ),
      loader: _package_card.loadLibrary,
    ),
  },
);
