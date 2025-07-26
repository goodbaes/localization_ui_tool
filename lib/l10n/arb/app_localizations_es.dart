// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Herramienta de UI de';

  @override
  String get search => 'Buscara';

  @override
  String get errorLoadingEntries => 'Error al cargar entradas';

  @override
  String editEntry(Object entryKey) {
    return 'Editar $entryKey';
  }

  @override
  String get saving => 'Guardando...';

  @override
  String get missingTranslations => 'Traducciones faltantes';

  @override
  String get noMissingTranslations =>
      'No se encontraron traducciones faltantes.';

  @override
  String get addEntry => 'Añadir nueva entrada';

  @override
  String get key => 'Clave';

  @override
  String get translation => 'Traducción';

  @override
  String get keyCannotBeEmpty => 'La clave no puede estar vacía';

  @override
  String get qwe => 'qwe';

  @override
  String get newKey => 'Nueva clave';

  @override
  String get add => 'Añadir';

  @override
  String get sessionAddedKeys => 'Claves añadidas en esta sesión';

  @override
  String get keyExists => 'La clave ya existe';

  @override
  String get qweqw => 'asdasd';

  @override
  String get title_onboarding => 'holla';

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
