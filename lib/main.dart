import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/application/di.dart';
import 'package:localization_ui_tool/application/navigation/router.dart';
import 'package:localization_ui_tool/core/models/app_theme.dart';
import 'package:localization_ui_tool/l10n/arb/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Locale> _supportedLocales = [];
  bool _isLoadingLocales = true;

  @override
  void initState() {
    super.initState();
    _loadSupportedLocales();
  }

  Future<void> _loadSupportedLocales() async {
    try {
      setState(() {
        _supportedLocales = AppLocalizations.supportedLocales;
        _isLoadingLocales = false;
      });
    } catch (e) {
      // Handle error, e.g., show a message or use a default locale list
      setState(() {
        _isLoadingLocales = false;
      });
      // Optionally, log the error or show a dialog
      debugPrint('Error loading supported locales: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingLocales) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationCubit>(
          create: (context) => LocalizationCubit(
            getAll: getIt(),
            saveEntry: getIt(),
            localizationService: getIt(),
          ),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(
            getSettings: getIt(),
            saveSettings: getIt(),
            directoryService: getIt(),
            checkArbDirectoryUseCase: getIt(),
            selectDirectoryUseCase: getIt(),
          )..load(), // Load settings when the app starts
        ),
      ],
      child: BlocConsumer<SettingsCubit, SettingsState>(
        // Changed to BlocConsumer
        listener: (context, state) {
          if (state is SettingsLoaded) {
            // Once settings are loaded, load localization entries
            context.read<LocalizationCubit>().loadEntries();
          }
        },
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return MaterialApp.router(
              routerConfig: router,
              locale: Locale(state.settings.locale),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: _supportedLocales,
              theme: FlexThemeData.light(
                scheme: state.settings.flexScheme,
              ),
              darkTheme: FlexThemeData.dark(
                scheme: state.settings.flexScheme,
              ),
              themeMode: ThemeMode.values[state.settings.themeMode.index],
            );
          }
          // Show a loading indicator while settings are being loaded
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}
