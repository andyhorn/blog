/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
import 'main.server.options.dart';

void main() {
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  runApp(
    Document(
      title: 'Andy Horn',
      meta: {
        'description': 'Personal portfolio and blog of Andy Horn, Flutter engineer and pub.dev package author.',
        'twitter:site': '@andyjhorn',
        'twitter:card': 'summary_large_image',
      },
      head: [
        // Font preconnect
        link(href: 'https://fonts.googleapis.com', rel: 'preconnect'),
        link(
          href: 'https://fonts.gstatic.com',
          rel: 'preconnect',
          attributes: {'crossorigin': ''},
        ),
        // Geist, Geist Mono, Inter from Google Fonts
        link(
          href:
              'https://fonts.googleapis.com/css2?family=Geist:wght@400;600;700&family=Geist+Mono:wght@400;600;700&family=Inter:wght@400;600;700&display=swap',
          rel: 'stylesheet',
        ),
        // OG tags (need property= attribute, not name=)
        meta(
          attributes: {
            'property': 'og:image',
            'content': 'https://andyhorn.dev/images/og-image.png',
          },
        ),
        // JSON-LD Person schema
        script(
          attributes: {'type': 'application/ld+json'},
          content: jsonEncode({
            '@context': 'https://schema.org',
            '@type': 'Person',
            'name': 'Andy Horn',
            'url': 'https://andyhorn.dev',
            'sameAs': [
              'https://github.com/andyhorn',
              'https://linkedin.com/in/andyjhorn',
              'https://pub.dev/publishers/andyhorn.dev',
            ],
          }),
        ),
        // highlight.js — syntax highlighting for code blocks in blog posts
        link(
          href: 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css',
          rel: 'stylesheet',
        ),
        script(
          src: 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js',
        ),
        script(
          src: 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/dart.min.js',
        ),
        script(content: 'document.addEventListener("DOMContentLoaded",function(){hljs.highlightAll();});'),
        // Flutter manifest and bootstrap
        link(href: 'manifest.json', rel: 'manifest'),
        script(src: 'flutter_bootstrap.js', async: true),
      ],
      body: App(),
    ),
  );
}
