// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:blog/components/blog_interactive_section.dart'
    deferred as _blog_interactive_section;
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
  },
);
