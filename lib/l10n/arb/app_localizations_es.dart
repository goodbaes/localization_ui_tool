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
  String get newKey => 'Nueva clave';

  @override
  String get add => 'Añadir';

  @override
  String get sessionAddedKeys => 'Claves añadidas en esta sesión';

  @override
  String get keyExists => 'La clave ya existe';

  @override
  String get title_onboarding => 'holla';

  @override
  String get start => 'start';

  @override
  String get settings => 'Ajustes';

  @override
  String get arbDirectory => 'Directorio ARB';

  @override
  String get notSet => 'No establecido';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get keyInvalidCharacters =>
      'La clave solo puede contener caracteres  y guiones bajos.';

  @override
  String get translationCannotBeEmpty => 'La traducción no puede estar vacía.';

  @override
  String get keyCannotStartWithAt => 'La clave no puede empezar con \"@\".';

  @override
  String get language => 'Idioma';

  @override
  String get keyCannotContainDigits => 'La clave no puede contener dígitos.';

  @override
  String get noArbFilesFound =>
      'No se encontraron archivos .arb en el directorio seleccionado.';

  @override
  String get macOSPermissionErrorTitle => 'Error de Permisos en macOS';

  @override
  String get macOSPermissionErrorExplanation =>
      'Parece que la aplicación no tiene los permisos necesarios para acceder al directorio seleccionado en macOS. Siga estos pasos para otorgar Acceso Total al Disco:';

  @override
  String get macOSPermissionErrorStepOne => '1. Cierre la aplicación.';

  @override
  String get macOSPermissionErrorStepTwo =>
      '2. Vaya a Configuración del Sistema (o Preferencias del Sistema) en su Mac.';

  @override
  String get macOSPermissionErrorStepThree =>
      '3. Seleccione Privacidad y Seguridad.';

  @override
  String get macOSPermissionErrorStepFour =>
      '4. Desplácese hacia abajo y busque Acceso Total al Disco.';

  @override
  String get macOSPermissionErrorStepFive =>
      '5. Haga clic en el icono de candado para desbloquear la configuración e ingrese su contraseña de administrador.';

  @override
  String get macOSPermissionErrorStepSix =>
      '6. Haga clic en el botón \'+\' para agregar una nueva aplicación.';

  @override
  String get macOSPermissionErrorStepSeven =>
      '7. Navegue hasta su aplicación (generalmente en build/macos/Build/Products/Debug/ o Release/ dentro de la carpeta de su proyecto) y selecciónela.';

  @override
  String get macOSPermissionErrorStepEight =>
      '8. Asegúrese de que el interruptor junto a su aplicación esté activado (azul).';

  @override
  String get macOSPermissionErrorButton => 'Mostrar Instrucciones';

  @override
  String get qwe => 'qwerr';

  @override
  String get qq => 'a';

  @override
  String get test => 'test';

  @override
  String get theme => 'Tema';

  @override
  String get www => 'www';

  @override
  String get qwerty => 'qwe';
}
