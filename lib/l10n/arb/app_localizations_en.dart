// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Localization UI Toolqqqqqwesdasd asd ';

  @override
  String get search => 'Search';

  @override
  String get errorLoadingEntries => 'Error loading entries';

  @override
  String editEntry(Object entryKey) {
    return 'Edit $entryKey';
  }

  @override
  String get saving => 'Saving...';

  @override
  String get missingTranslations => 'Missing Translations';

  @override
  String get noMissingTranslations => 'No missing translations found.';

  @override
  String get addEntry => 'Add New Entry';

  @override
  String get key => 'Key';

  @override
  String get translation => 'Translation';

  @override
  String get keyCannotBeEmpty => 'Key cannot be empty';
}
