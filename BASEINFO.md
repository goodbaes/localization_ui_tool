## Architecture Overview

Этот POC разделён на четыре основных модуля:

1. **core** – модели, интерфейсы, бизнес-логика (use cases)
2. **infrastructure** – реализация репозиториев, парсинг ARB, доступ к файловой системе, persistance
3. **application** – BLoC/Cubit, DI, сервисы, координация между core и presentation
4. **presentation** – Flutter UI, навигация (GoRouter), локализация самого приложения

Общие зависимости и DI через `get_it`.

---

### 1. core module

**Location:** `lib/core/`

#### Freezed-модель

```dart
@freezed
class LocalizationEntry with _$LocalizationEntry {
  const factory LocalizationEntry({
    required String key,
    required Map<String, String> values, // locale -> translated text
  }) = _LocalizationEntry;
}
```

#### Интерфейсы репозиториев

```dart
abstract class LocalizationRepository {
  Future<List<LocalizationEntry>> loadAll();
  Future<void> saveEntry(LocalizationEntry entry);
}

abstract class SettingsRepository {
  Future<String?> get directoryPath;
  Future<void> set directoryPath(String path);
  Future<bool> get autoSave;
  Future<void> set autoSave(bool value);
}
```

#### Use Cases

```dart
class GetAllEntriesUseCase {
  final LocalizationRepository repo;
  GetAllEntriesUseCase(this.repo);
  Future<List<LocalizationEntry>> call() => repo.loadAll();
}

class SaveEntryUseCase {
  final LocalizationRepository repo;
  SaveEntryUseCase(this.repo);
  Future<void> call(LocalizationEntry entry) async {
    // валидация ключа, проверка коллизий
    await repo.saveEntry(entry);
  }
}

class GetSettingsUseCase {
  final SettingsRepository repo;
  GetSettingsUseCase(this.repo);
  Future<Settings> call() async {
    return Settings(
      directoryPath: await repo.directoryPath,
      autoSave: await repo.autoSave,
    );
  }
}

class SaveSettingsUseCase {
  final SettingsRepository repo;
  SaveSettingsUseCase(this.repo);
  Future<void> call(Settings settings) async {
    await repo.setDirectoryPath(settings.directoryPath);
    await repo.setAutoSave(settings.autoSave);
  }
}
```

---

### 2. infrastructure module

**Location:** `lib/infrastructure/`

#### ARB Parser & File Access

```dart
class ArbParser {
  Map<String, dynamic> parse(String content) => json.decode(content);
  String serialize(Map<String, dynamic> jsonMap) => const JsonEncoder.withIndent('  ').convert(jsonMap);
}
```

#### Репозитории

```dart
class ArbFileRepository implements LocalizationRepository {
  final String directoryPath;
  final ArbParser parser;

  ArbFileRepository({required this.directoryPath, required this.parser});

  @override
  Future<List<LocalizationEntry>> loadAll() async {
    return compute(_parseAllFiles, { 'path': directoryPath });
  }

  static List<LocalizationEntry> _parseAllFiles(Map<String, String> args) {
    // читаем все arb, собираем уникальные ключи, заполняем values map
  }

  @override
  Future<void> saveEntry(LocalizationEntry entry) async {
    // найти файлы, обновить JSON, сохранить
  }
}

class LocalSettingsRepository implements SettingsRepository {
  final SharedPreferences prefs;
  LocalSettingsRepository(this.prefs);

  @override
  Future<String?> get directoryPath => prefs.getString('directoryPath');
  @override
  Future<void> set directoryPath(String path) => prefs.setString('directoryPath', path);
  @override
  Future<bool> get autoSave => prefs.getBool('autoSave') ?? false;
  @override
  Future<void> set autoSave(bool value) => prefs.setBool('autoSave', value);
}
```

---

### 3. application module

**Location:** `lib/application/`

#### DI Setup (get\_it)

```dart
final getIt = GetIt.instance;

void setupDI() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SettingsRepository>(LocalSettingsRepository(prefs));
  getIt.registerSingleton<ArbParser>(ArbParser());
  getIt.registerFactory<LocalizationRepository>(
    () => ArbFileRepository(
      directoryPath: getIt<SettingsRepository>().directoryPath as String,
      parser: getIt<ArbParser>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllEntriesUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveEntryUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSettingsUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveSettingsUseCase(getIt()));
}
```

#### Cubits

```dart
class LocalizationCubit extends Cubit<LocalizationState> {
  final GetAllEntriesUseCase getAll;
  final SaveEntryUseCase saveEntry;
  LocalizationCubit({required this.getAll, required this.saveEntry}) : super(LocalizationInitial());

  Future<void> loadEntries() async {
    emit(LocalizationLoading());
    final list = await getAll();
    emit(LocalizationLoaded(list));
  }

  Future<void> updateEntry(LocalizationEntry entry) async {
    emit(LocalizationSaving());
    await saveEntry(entry);
    await loadEntries();
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;
  SettingsCubit({required this.getSettings, required this.saveSettings}) : super(SettingsInitial());

  Future<void> load() async {
    final settings = await getSettings();
    emit(SettingsLoaded(settings));
  }

  Future<void> update(Settings settings) async {
    await saveSettings(settings);
    emit(SettingsLoaded(settings));
  }
}
```

#### Routing (GoRouter)

```dart
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => EntryListPage()),
    GoRoute(path: '/edit/:key', builder: (_, state) => EntryEditPage(key: state.params['key']!)),
    GoRoute(path: '/missing', builder: (_, __) => MissingTranslationsPage()),
    GoRoute(path: '/settings', builder: (_, __) => SettingsPage()),
  ],
);
```

---

### 4. presentation module

**Location:** `lib/presentation/`

* **EntryListPage**: отображает `LocalizationLoaded` список, SearchField
* **EntryEditPage**: редактирует и сохраняет одну запись
* **MissingTranslationsPage**: фильтрует состояния `LocalizationLoaded` по пустым переводам
* **SettingsPage**: форма выбора папки (FilePicker) и переключатель autoSave
* **Common Widgets**: Toast, LoadingIndicator, ErrorDialog
* **i18n**: `intl` package, `lib/l10n/` для RU/EN ресурсов

---

Теперь учтены DI, настройка через SettingsRepository, SharedPreferences и плейс для SettingsPage. Фризед-модель и разделение слоёв. Если что-то ещё упустил — скажи!

