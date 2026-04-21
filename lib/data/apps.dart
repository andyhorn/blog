import '../models/app.dart';

const apps = [
  App(
    title: 'FocusFlow',
    description:
        'A minimalist productivity app with Pomodoro timers, task management, and focus sessions. Built with Flutter & Bloc.',
    storeUrl: 'https://apps.apple.com/',
    tags: ['Flutter', 'Productivity'],
    imageUrl: 'images/focus-flow.png',
    badgeColor: '#A855F7',
  ),
  App(
    title: 'TrailMapper',
    description: 'Offline-first hiking trail app with GPX track recording, elevation charts, and waypoints.',
    storeUrl: 'https://apps.apple.com/',
    tags: ['Flutter', 'Outdoor'],
    imageUrl: 'images/trail-mapper.png',
    badgeColor: '#3B82F6',
  ),
  App(
    title: 'BudgetPal',
    description: 'Smart personal finance tracker with categories, charts, and monthly budget goals.',
    storeUrl: 'https://apps.apple.com/',
    tags: ['Flutter', 'Finance'],
    imageUrl: 'images/budget-pal.png',
    badgeColor: '#10B981',
  ),
  App(
    title: 'DailyLens',
    description: 'A photo journaling app with AI tagging, timeline view, and private encrypted albums.',
    storeUrl: 'https://apps.apple.com/',
    tags: ['Flutter', 'Photography'],
    imageUrl: 'images/daily-lens.png',
    badgeColor: '#F59E0B',
  ),
];
