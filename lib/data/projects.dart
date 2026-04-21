import '../models/project.dart';

const List<Project> projects = [
  Project(
    title: 'Personal Portfolio & Blog',
    description:
        'A personal portfolio and blog built with Jaspr, a Dart web framework for static site generation with server-side rendering.',
    url: 'https://github.com/yourusername/blog',
    tags: ['Dart', 'Jaspr', 'Web'],
  ),
  Project(
    title: 'Flutter Mobile App',
    description:
        'A cross-platform mobile app built with Flutter, featuring clean architecture and BLoC state management.',
    url: 'https://github.com/yourusername/flutter-app',
    tags: ['Flutter', 'Dart', 'Mobile'],
  ),
  Project(
    title: 'CLI Tool',
    description: 'A command-line utility written in Dart for automating development workflows, published on pub.dev.',
    url: 'https://github.com/yourusername/cli-tool',
    tags: ['Dart', 'CLI', 'DevTools'],
  ),
];
