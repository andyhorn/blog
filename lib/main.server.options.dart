// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:blog/components/about_section.dart' as _about_section;
import 'package:blog/components/app_card.dart' as _app_card;
import 'package:blog/components/apps_section.dart' as _apps_section;
import 'package:blog/components/blog_preview_card.dart' as _blog_preview_card;
import 'package:blog/components/blog_preview_section.dart'
    as _blog_preview_section;
import 'package:blog/components/bridge_section.dart' as _bridge_section;
import 'package:blog/components/contact_section.dart' as _contact_section;
import 'package:blog/components/header.dart' as _header;
import 'package:blog/components/hero_section.dart' as _hero_section;
import 'package:blog/components/package_card.dart' as _package_card;
import 'package:blog/components/packages_section.dart' as _packages_section;
import 'package:blog/components/site_footer.dart' as _site_footer;
import 'package:blog/components/stats_strip.dart' as _stats_strip;
import 'package:blog/constants/theme.dart' as _theme;
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
  styles: () => [
    ..._theme.globalStyles,
    ..._app.App.styles,
    ..._about_section.AboutSection.styles,
    ..._app_card.AppCard.styles,
    ..._apps_section.AppsSection.styles,
    ..._blog_preview_card.BlogPreviewCard.styles,
    ..._blog_preview_section.BlogPreviewSection.styles,
    ..._bridge_section.BridgeSection.styles,
    ..._contact_section.ContactSection.styles,
    ..._header.Header.styles,
    ..._hero_section.HeroSection.styles,
    ..._package_card.PackageCard.styles,
    ..._packages_section.PackagesSection.styles,
    ..._site_footer.SiteFooter.styles,
    ..._stats_strip.StatsStrip.styles,
  ],
);
