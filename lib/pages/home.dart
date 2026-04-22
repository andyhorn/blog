import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/about_section.dart';
import '../components/blog_preview_section.dart';
import '../components/bridge_section.dart';
import '../components/contact_section.dart';
import '../components/hero_section.dart';
import '../components/packages_section.dart';
import '../components/stats_strip.dart';
import '../models/post.dart';

class Home extends StatelessComponent {
  const Home({required this.recentPosts, super.key});

  final List<Post> recentPosts;

  @override
  Component build(BuildContext context) {
    return div([
      Document.head(
        meta: {
          'description': 'Portfolio and blog of Andy Horn, Flutter engineer and pub.dev package author.',
          'og:title': 'Andy Horn — Flutter Engineer & Package Author',
          'og:type': 'website',
        },
      ),
      const HeroSection(),
      const BridgeSection(),
      const StatsStrip(),
      const AboutSection(),
      const PackagesSection(),
      BlogPreviewSection(posts: recentPosts),
      const ContactSection(),
    ]);
  }
}
