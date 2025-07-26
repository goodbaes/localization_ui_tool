import 'package:freezed_annotation/freezed_annotation.dart';

part 'localization_entry.freezed.dart';
part 'localization_entry.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class LocalizationEntry with _$LocalizationEntry {
  const factory LocalizationEntry({
    required String key,
    required Map<String, String> values, // locale -> translated text
  }) = _$LocalizationEntryImpl;
}
