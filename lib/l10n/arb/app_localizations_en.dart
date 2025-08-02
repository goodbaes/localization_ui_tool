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
  String get newKey => 'New Key';

  @override
  String get add => 'Add';

  @override
  String get sessionAddedKeys => 'Keys added in this session';

  @override
  String get keyExists => 'Key already exists';

  @override
  String get title_onboarding => 'hello';

  @override
  String get start => 'start';

  @override
  String get settings => 'Settings';

  @override
  String get arbDirectory => 'ARB Directory';

  @override
  String get notSet => 'Not set';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get keyInvalidCharacters =>
      'Key can only contain characters and underscores.';

  @override
  String get translationCannotBeEmpty => 'Translation cannot be empty.';

  @override
  String get keyCannotStartWithAt => 'Key cannot start with \"@\".';

  @override
  String get language => 'Language';

  @override
  String get keyCannotContainDigits => 'Key cannot contain digits.';

  @override
  String get noArbFilesFound =>
      'No .arb files found in the selected directory.';

  @override
  String get macOSPermissionErrorTitle => 'macOS Permission Error';

  @override
  String get macOSPermissionErrorExplanation =>
      'It seems like the application doesn\'t have the necessary permissions to access the selected directory on macOS. Please follow these steps to grant Full Disk Access:';

  @override
  String get macOSPermissionErrorStepOne => '1. Close the application.';

  @override
  String get macOSPermissionErrorStepTwo =>
      '2. Go to System Settings (or System Preferences) on your Mac.';

  @override
  String get macOSPermissionErrorStepThree => '3. Select Privacy & Security.';

  @override
  String get macOSPermissionErrorStepFour =>
      '4. Scroll down and find Full Disk Access.';

  @override
  String get macOSPermissionErrorStepFive =>
      '5. Click the lock icon to unlock settings and enter your administrator password.';

  @override
  String get macOSPermissionErrorStepSix =>
      '6. Click the \'+\' button to add a new application.';

  @override
  String get macOSPermissionErrorStepSeven =>
      '7. Navigate to your application (usually in build/macos/Build/Products/Debug/ or Release/ inside your project folder) and select it.';

  @override
  String get macOSPermissionErrorStepEight =>
      '8. Ensure the toggle next to your application is turned on (blue).';

  @override
  String get macOSPermissionErrorButton => 'Show Instructions';

  @override
  String get qwe => 'qwee';

  @override
  String get qq => 'q';

  @override
  String get test => 'test';

  @override
  String get theme => 'Theme';

  @override
  String get www => 'www';

  @override
  String get qwerty => 'qwe';

  @override
  String get settingsThemeMode => 'Theme Mode';

  @override
  String get settingsThemeColorScheme => 'Theme Color Scheme';

  @override
  String get entryListOpenFolder => 'Open folder';
}
