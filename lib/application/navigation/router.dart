import 'package:go_router/go_router.dart';
import 'package:localization_ui_tool/presentation/screens/entry_edit_page.dart';
import 'package:localization_ui_tool/presentation/screens/entry_list_page.dart';
import 'package:localization_ui_tool/presentation/screens/missing_translations_page.dart';
import 'package:localization_ui_tool/presentation/screens/settings_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const EntryListPage()),
    GoRoute(path: '/edit/:key', builder: (_, state) => EntryEditPage(entryKey: state.pathParameters['key']!)),
    GoRoute(path: '/missing', builder: (_, __) => const MissingTranslationsPage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    GoRoute(path: '/add_entry', builder: (_, __) => const EntryEditPage(entryKey: '')), // New route for adding entry
  ],
);
