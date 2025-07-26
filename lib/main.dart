import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/application/di.dart';
import 'package:localization_ui_tool/application/navigation/router.dart';
import 'package:localization_ui_tool/l10n/arb/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationCubit>(
          create: (context) => LocalizationCubit(
            getAll: getIt(),
            saveEntry: getIt(),
          ),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(
            getSettings: getIt(),
            saveSettings: getIt(),
          )..load(), // Load settings when the app starts
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          Locale? currentLocale;
          if (state is SettingsLoaded) {
            currentLocale = state.settings.locale;
          }
          return MaterialApp.router(
            title: AppLocalizations.of(context)?.appTitle,
            routerConfig: router,
            locale: currentLocale, // Use the locale from settings
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state is SettingsLoaded ? state.settings.themeMode : ThemeMode.system,
          );
        },
      ),
    );
  }
}
