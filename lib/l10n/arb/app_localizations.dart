import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Localization UI Tools'**
  String get appTitle;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @errorLoadingEntries.
  ///
  /// In en, this message translates to:
  /// **'Error loading entries'**
  String get errorLoadingEntries;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit {entryKey}'**
  String editEntry(Object entryKey);

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @missingTranslations.
  ///
  /// In en, this message translates to:
  /// **'Missing Translations'**
  String get missingTranslations;

  /// No description provided for @noMissingTranslations.
  ///
  /// In en, this message translates to:
  /// **'No missing translations found.'**
  String get noMissingTranslations;

  /// No description provided for @addEntry.
  ///
  /// In en, this message translates to:
  /// **'Add New Entry'**
  String get addEntry;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get key;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @keyCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Key cannot be empty'**
  String get keyCannotBeEmpty;

  /// No description provided for @newKey.
  ///
  /// In en, this message translates to:
  /// **'New Key'**
  String get newKey;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @sessionAddedKeys.
  ///
  /// In en, this message translates to:
  /// **'Keys added in this session'**
  String get sessionAddedKeys;

  /// No description provided for @keyExists.
  ///
  /// In en, this message translates to:
  /// **'Key already exists'**
  String get keyExists;

  /// No description provided for @title_onboarding.
  ///
  /// In en, this message translates to:
  /// **'hello'**
  String get title_onboarding;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get start;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @arbDirectory.
  ///
  /// In en, this message translates to:
  /// **'ARB Directory'**
  String get arbDirectory;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @keyInvalidCharacters.
  ///
  /// In en, this message translates to:
  /// **'Key can only contain characters and underscores.'**
  String get keyInvalidCharacters;

  /// No description provided for @translationCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Translation cannot be empty.'**
  String get translationCannotBeEmpty;

  /// No description provided for @keyCannotStartWithAt.
  ///
  /// In en, this message translates to:
  /// **'Key cannot start with \"@\".'**
  String get keyCannotStartWithAt;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @keyCannotContainDigits.
  ///
  /// In en, this message translates to:
  /// **'Key cannot contain digits.'**
  String get keyCannotContainDigits;

  /// No description provided for @noArbFilesFound.
  ///
  /// In en, this message translates to:
  /// **'No .arb files found in the selected directory.'**
  String get noArbFilesFound;

  /// No description provided for @macOSPermissionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'macOS Permission Error'**
  String get macOSPermissionErrorTitle;

  /// No description provided for @macOSPermissionErrorExplanation.
  ///
  /// In en, this message translates to:
  /// **'It seems like the application doesn\'t have the necessary permissions to access the selected directory on macOS. Please follow these steps to grant Full Disk Access:'**
  String get macOSPermissionErrorExplanation;

  /// No description provided for @macOSPermissionErrorStepOne.
  ///
  /// In en, this message translates to:
  /// **'1. Close the application.'**
  String get macOSPermissionErrorStepOne;

  /// No description provided for @macOSPermissionErrorStepTwo.
  ///
  /// In en, this message translates to:
  /// **'2. Go to System Settings (or System Preferences) on your Mac.'**
  String get macOSPermissionErrorStepTwo;

  /// No description provided for @macOSPermissionErrorStepThree.
  ///
  /// In en, this message translates to:
  /// **'3. Select Privacy & Security.'**
  String get macOSPermissionErrorStepThree;

  /// No description provided for @macOSPermissionErrorStepFour.
  ///
  /// In en, this message translates to:
  /// **'4. Scroll down and find Full Disk Access.'**
  String get macOSPermissionErrorStepFour;

  /// No description provided for @macOSPermissionErrorStepFive.
  ///
  /// In en, this message translates to:
  /// **'5. Click the lock icon to unlock settings and enter your administrator password.'**
  String get macOSPermissionErrorStepFive;

  /// No description provided for @macOSPermissionErrorStepSix.
  ///
  /// In en, this message translates to:
  /// **'6. Click the \'+\' button to add a new application.'**
  String get macOSPermissionErrorStepSix;

  /// No description provided for @macOSPermissionErrorStepSeven.
  ///
  /// In en, this message translates to:
  /// **'7. Navigate to your application (usually in build/macos/Build/Products/Debug/ or Release/ inside your project folder) and select it.'**
  String get macOSPermissionErrorStepSeven;

  /// No description provided for @macOSPermissionErrorStepEight.
  ///
  /// In en, this message translates to:
  /// **'8. Ensure the toggle next to your application is turned on (blue).'**
  String get macOSPermissionErrorStepEight;

  /// No description provided for @macOSPermissionErrorButton.
  ///
  /// In en, this message translates to:
  /// **'Show Instructions'**
  String get macOSPermissionErrorButton;

  /// No description provided for @qwe.
  ///
  /// In en, this message translates to:
  /// **'qwee'**
  String get qwe;

  /// No description provided for @qq.
  ///
  /// In en, this message translates to:
  /// **'q'**
  String get qq;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'test'**
  String get test;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @www.
  ///
  /// In en, this message translates to:
  /// **'www'**
  String get www;

  /// No description provided for @qwerty.
  ///
  /// In en, this message translates to:
  /// **'qwe'**
  String get qwerty;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settingsThemeMode;

  /// No description provided for @settingsThemeColorScheme.
  ///
  /// In en, this message translates to:
  /// **'Theme Color Scheme'**
  String get settingsThemeColorScheme;

  /// No description provided for @entryListOpenFolder.
  ///
  /// In en, this message translates to:
  /// **'Open folder'**
  String get entryListOpenFolder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
