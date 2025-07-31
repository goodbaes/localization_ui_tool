import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const LocalizationAdderApp());
}

class LocalizationAdderApp extends StatelessWidget {
  const LocalizationAdderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARB Key Adder (с поддержкой вложенности)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AddLocalizationScreen(),
    );
  }
}

class AddLocalizationScreen extends StatefulWidget {
  const AddLocalizationScreen({super.key});

  @override
  State<AddLocalizationScreen> createState() => _AddLocalizationScreenState();
}

class _AddLocalizationScreenState extends State<AddLocalizationScreen> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _folderPathController = TextEditingController();
  String _status = 'Готово';
  bool _isProcessing = false;
  final List<String> _errors = [];
  final List<String> _successes = [];
  // Кэш всех ключей (полные пути, как строки)
  final Set<String> _existingKeys = {};
  // Список языков, найденных в ARB файлах
  List<String> _languages = [];
  // Структура: язык → значение
  final Map<String, String> _existingValues = {};
  // Статус: false - только ключ, true - поля локализаций
  bool _showLocalizationFields = false;
  // Контроллеры для значений по языкам
  final Map<String, TextEditingController> _languageValueControllers = {};

  Future<void> _scanArbFiles(String folderPath) async {
    final dir = Directory(folderPath);
    if (!dir.existsSync()) {
      setState(() {
        _status = 'Ошибка: папка не существует';
        _errors.add('Папка $folderPath не найдена');
      });
      return;
    }
    _existingKeys.clear();
    _errors.clear();
    _languages = _detectLanguages(folderPath);
    _existingValues.clear();

    try {
      await for (final file in dir.list(recursive: true)) {
        if (file is File && path.extension(file.path) == '.arb') {
          final content = await file.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          _collectKeysFromMap(json, '');
        }
      }
      setState(() {
        _status = 'Найдено ${_existingKeys.length} уникальных ключей (включая вложенные)';
      });
    } catch (e) {
      setState(() {
        _status = 'Ошибка при чтении файлов';
        _errors.add('Ошибка: $e');
      });
    }
  }

  // Определяет языковые коды из имен ARB файлов
  List<String> _detectLanguages(String folderPath) {
    final dir = Directory(folderPath);
    final languages = <String>{};
    for (final file in dir.listSync(recursive: true)) {
      if (file is File && path.extension(file.path) == '.arb') {
        final fileName = path.basenameWithoutExtension(file.path);
        final match = RegExp(r'_(\w{2})$').firstMatch(fileName);
        if (match != null && match.group(1) != null) {
          languages.add(match.group(1)!);
        }
      }
    }
    return languages.toList();
  }

  // Рекурсивно собираем все ключи в формате "a.b.c"
  void _collectKeysFromMap(Map<String, dynamic> map, String prefix) {
    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;
      final fullKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        _collectKeysFromMap(value, fullKey);
      } else {
        _existingKeys.add(fullKey);
      }
    }
  }

  Future<void> _checkKey() async {
    final key = _keyController.text.trim();
    final folderPath = _folderPathController.text.trim();

    if (key.isEmpty) {
      setState(() {
        _status = 'Ошибка: заполните ключ';
      });
      return;
    }

    if (folderPath.isEmpty) {
      setState(() {
        _status = 'Ошибка: укажите путь к папке';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _status = 'Проверка ключа...';
      _successes.clear();
      _errors.clear();
    });

    // Сначала сканируем все .arb файлы
    await _scanArbFiles(folderPath);

    // Проверяем, есть ли такой ключ (полный путь)
    if (_existingKeys.contains(key)) {
      // Ключ существует, получаем значения для всех языков
      _existingValues.clear();
      for (final lang in _languages) {
        final value = _getValueForLanguage(key, lang, folderPath);
        _existingValues[lang] = value;
      }

      // Создаем контроллеры для каждого языка с существующими значениями
      _languageValueControllers.clear();
      for (final lang in _languages) {
        _languageValueControllers[lang] = TextEditingController(text: _existingValues[lang]);
      }

      setState(() {
        _status = 'Ключ "$key" найден. Заполните значения или нажмите "Добавить ключ"';
        _showLocalizationFields = true;
        _isProcessing = false;
      });
    } else {
      // Ключ не существует, создаем пустые контроллеры
      _languageValueControllers.clear();
      for (final lang in _languages) {
        _languageValueControllers[lang] = TextEditingController();
      }

      setState(() {
        _status = 'Ключ "$key" не найден. Введите значения для всех локализаций';
        _showLocalizationFields = true;
        _isProcessing = false;
      });
    }
  }

  String _getValueForLanguage(String key, String lang, String folderPath) {
    final fileName = 'app_$lang.arb';
    final filePath = path.join(folderPath, fileName);
    final file = File(filePath);

    if (file.existsSync()) {
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return _getValueFromMap(json, key.split('.'));
    }
    return '';
  }

  String _getValueFromMap(Map<String, dynamic> map, List<String> parts) {
    if (parts.isEmpty) return '';

    final key = parts.first;
    if (parts.length == 1) {
      return map[key]?.toString() ?? '';
    }

    if (map.containsKey(key) && map[key] is Map<String, dynamic>) {
      return _getValueFromMap(map[key] as Map<String, dynamic>, parts.sublist(1));
    }

    return '';
  }

  Future<void> _addKey() async {
    final key = _keyController.text.trim();
    final folderPath = _folderPathController.text.trim();

    if (key.isEmpty) {
      setState(() {
        _status = 'Ошибка: заполните ключ';
      });
      return;
    }

    if (folderPath.isEmpty) {
      setState(() {
        _status = 'Ошибка: укажите путь к папке';
      });
      return;
    }

    // Проверяем, что значения введены для всех языков
    for (final lang in _languages) {
      if (_languageValueControllers[lang]!.text.isEmpty) {
        setState(() {
          _status = 'Ошибка: заполните значение для всех языков';
        });
        return;
      }
    }

    setState(() {
      _isProcessing = true;
      _status = 'Добавление ключа...';
      _successes.clear();
      _errors.clear();
    });

    var addedCount = 0;
    final errors = <String>[];
    try {
      for (final lang in _languages) {
        final value = _languageValueControllers[lang]?.text;
        final fileName = 'app_$lang.arb';
        final filePath = path.join(folderPath, fileName);
        final file = File(filePath);

        if (file.existsSync()) {
          final content = await file.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          final parts = key.split('.');
          final newJson = _createNestedMap(parts, value);
          final updatedJson = _mergeMaps(json, parts, newJson);
          final updatedContent = jsonEncode(updatedJson);
          await file.writeAsString(updatedContent);
          addedCount++;
        } else {
          errors.add('Файл $fileName не найден');
        }
      }

      setState(() {
        _isProcessing = false; // Сбрасываем состояние обработки
        _status = 'Успешно добавлено в $addedCount файлов';
        _successes.add('Ключ "$key" добавлен в $addedCount .arb файлах.');
      });
    } catch (e) {
      setState(() {
        _isProcessing = false; // Сбрасываем состояние обработки
        _status = 'Ошибка при записи файлов';
        errors.add('Ошибка: $e');
      });
    }

    if (errors.isNotEmpty) {
      setState(() {
        _errors.addAll(errors);
      });
    }
  }

  // Создаёт вложенную структуру: ['a', 'b', 'c'] → { "a": { "b": { "c": "value" } } }
  Map<String, dynamic> _createNestedMap(List<String> parts, dynamic value) {
    if (parts.isEmpty) return {};
    if (parts.length == 1) return {parts[0]: value};
    final inner = _createNestedMap(parts.sublist(1), value);
    return {parts[0]: inner};
  }

  // Объединяет два JSON: вставляет вложенный объект по пути parts
  Map<String, dynamic> _mergeMaps(
    Map<String, dynamic> base,
    List<String> parts,
    Map<String, dynamic> newPart,
  ) {
    final result = Map<String, dynamic>.from(base);
    var current = result;
    for (var i = 0; i < parts.length - 1; i++) {
      final part = parts[i];
      if (!current.containsKey(part)) {
        current[part] = {};
      }
      if (current[part] is! Map<String, dynamic>) {
        // Если уже не объект — заменяем
        current[part] = {};
      }
      current = current[part] as Map<String, dynamic>;
    }
    final last = parts.last;
    if (current.containsKey(last)) {
      // Уже есть — но мы не перезаписываем, а предупреждаем
      // (уже проверили в _existingKeys, так что тут быть не должно)
    }
    current[last] = newPart[last]; // Только последний уровень
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить строку локализации (вложенность)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _folderPathController,
              decoration: InputDecoration(
                labelText: 'Путь к папке с .arb файлами',
                hintText: '~/localizations или /Users/.../localizations',
                prefixIcon: const Icon(Icons.folder_open),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFileAndDirectoryPaths();
                if (result != null) {
                  _folderPathController.text = result.first;
                }
              },
              child: const Text('Выбрать папку'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: 'Ключ (например: user.profile.title)',
                prefixIcon: Icon(Icons.key),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _checkKey,
              icon: _isProcessing
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : const Icon(Icons.search),
              label: Text(_isProcessing ? 'Проверка...' : 'Проверить ключ'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            if (_showLocalizationFields)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Значения для локализаций:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._languages.map(
                    (lang) => TextField(
                      controller: _languageValueControllers[lang],
                      decoration: InputDecoration(
                        labelText: 'Значение для $lang',
                        prefixIcon: const Icon(Icons.edit),
                      ),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _addKey,
                    icon: _isProcessing
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Icon(Icons.add),
                    label: Text(_isProcessing ? 'Добавление...' : 'Добавить ключ'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (_status.isNotEmpty)
              Card(
                color: _status.startsWith('Ошибка')
                    ? Colors.red[50]
                    : _status.contains('успешно')
                    ? Colors.green[50]
                    : Colors.grey[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _status,
                    style: TextStyle(
                      color: _status.startsWith('Ошибка')
                          ? Colors.red[700]
                          : _status.contains('успешно')
                          ? Colors.green[700]
                          : Colors.black,
                      fontWeight: _status.contains('успешно') ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ),
            if (_errors.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ошибки:', style: TextStyle(color: Colors.red)),
                  ..._errors.map(
                    (err) => Text('- $err', style: const TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            if (_successes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Успехи:', style: TextStyle(color: Colors.green)),
                  ..._successes.map(
                    (succ) => Text('- $succ', style: const TextStyle(color: Colors.green)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _folderPathController.dispose();
    for (final controller in _languageValueControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
