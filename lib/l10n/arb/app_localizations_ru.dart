// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Инструмент локализации UI';

  @override
  String get search => 'Поиск';

  @override
  String get errorLoadingEntries => 'Ошибка загрузки записей';

  @override
  String editEntry(Object entryKey) {
    return 'Редактировать $entryKey';
  }

  @override
  String get saving => 'Сохранение...';

  @override
  String get missingTranslations => 'Отсутствующие переводы';

  @override
  String get noMissingTranslations => 'Отсутствующие переводы не найдены.';

  @override
  String get addEntry => 'Добавить новую запись';

  @override
  String get key => 'Ключ';

  @override
  String get translation => 'Перевод';

  @override
  String get keyCannotBeEmpty => 'Ключ не может быть пустым';

  @override
  String get newKey => 'Новый ключ';

  @override
  String get add => 'Добавить';

  @override
  String get sessionAddedKeys => 'Ключи, добавленные в этой сессии';

  @override
  String get keyExists => 'Ключ уже существует';

  @override
  String get title_onboarding => 'привет';

  @override
  String get start => 'начать';

  @override
  String get settings => 'Настройки';

  @override
  String get arbDirectory => 'Директория ARB';

  @override
  String get notSet => 'Не установлено';

  @override
  String get error => 'Ошибка';

  @override
  String get ok => 'ОК';

  @override
  String get qwe => 'qwerr';

  @override
  String get qweg => 'r';

  @override
  String get rrrrrr => 'qe';

  @override
  String get qwe2 => 'qwe';

  @override
  String get keyInvalidCharacters =>
      'Ключ может содержать только буквенно-цифровые символы и подчеркивания.';

  @override
  String get translationCannotBeEmpty => 'Перевод не может быть пустым.';

  @override
  String get keyCannotStartWithAt => 'Ключ не может начинаться с \"@\".';
}
