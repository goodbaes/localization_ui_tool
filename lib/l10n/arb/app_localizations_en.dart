// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Localization UI Tools';

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

  @override
  String get qwe => 'qwe';

  @override
  String get newKey => 'New Key';

  @override
  String get add => 'Add';

  @override
  String get sessionAddedKeys => 'Keys added in this session';

  @override
  String get keyExists => 'Key already exists';

  @override
  String get qweqw => 'asdasd';

  @override
  String get title_onboarding => 'hello';

  @override
  String get app => 'app';

  @override
  String get start => 'start';

  @override
  String get r => 'r';

  @override
  String get tt => 'tt';

  @override
  String get title => 'asd';
}
