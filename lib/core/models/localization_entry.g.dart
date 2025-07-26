// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalizationEntry _$LocalizationEntryFromJson(Map<String, dynamic> json) =>
    LocalizationEntry(
      key: json['key'] as String,
      values: Map<String, String>.from(json['values'] as Map),
    );

Map<String, dynamic> _$LocalizationEntryToJson(LocalizationEntry instance) =>
    <String, dynamic>{'key': instance.key, 'values': instance.values};
