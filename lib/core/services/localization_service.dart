import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';
import 'package:rxdart/subjects.dart';

class LocalizationService {
  LocalizationService(this._repository);
  final LocalizationRepository _repository;

  final BehaviorSubject<List<LocalizationEntry>> _entriesSubject =
      BehaviorSubject<List<LocalizationEntry>>();

  Stream<List<LocalizationEntry>> get entriesStream => _entriesSubject.stream;

  Future<void> loadAll() async {
    final entries = await _repository.loadAll();
    _entriesSubject.add(entries);
  }
}
