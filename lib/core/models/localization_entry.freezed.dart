// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'localization_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LocalizationEntry {
  String get key => throw _privateConstructorUsedError;
  Map<String, String> get values =>
      throw _privateConstructorUsedError; // locale -> translated text
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of LocalizationEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalizationEntryCopyWith<LocalizationEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalizationEntryCopyWith<$Res> {
  factory $LocalizationEntryCopyWith(
    LocalizationEntry value,
    $Res Function(LocalizationEntry) then,
  ) = _$LocalizationEntryCopyWithImpl<$Res, LocalizationEntry>;
  @useResult
  $Res call({String key, Map<String, String> values, String? description});
}

/// @nodoc
class _$LocalizationEntryCopyWithImpl<$Res, $Val extends LocalizationEntry>
    implements $LocalizationEntryCopyWith<$Res> {
  _$LocalizationEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalizationEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? values = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            values: null == values
                ? _value.values
                : values // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$$LocalizationEntryImplImplCopyWith<$Res>
    implements $LocalizationEntryCopyWith<$Res> {
  factory _$$$LocalizationEntryImplImplCopyWith(
    _$$LocalizationEntryImplImpl value,
    $Res Function(_$$LocalizationEntryImplImpl) then,
  ) = __$$$LocalizationEntryImplImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, Map<String, String> values, String? description});
}

/// @nodoc
class __$$$LocalizationEntryImplImplCopyWithImpl<$Res>
    extends _$LocalizationEntryCopyWithImpl<$Res, _$$LocalizationEntryImplImpl>
    implements _$$$LocalizationEntryImplImplCopyWith<$Res> {
  __$$$LocalizationEntryImplImplCopyWithImpl(
    _$$LocalizationEntryImplImpl _value,
    $Res Function(_$$LocalizationEntryImplImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocalizationEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? values = null,
    Object? description = freezed,
  }) {
    return _then(
      _$$LocalizationEntryImplImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        values: null == values
            ? _value._values
            : values // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$$LocalizationEntryImplImpl implements _$LocalizationEntryImpl {
  const _$$LocalizationEntryImplImpl({
    required this.key,
    required final Map<String, String> values,
    this.description,
  }) : _values = values;

  @override
  final String key;
  final Map<String, String> _values;
  @override
  Map<String, String> get values {
    if (_values is EqualUnmodifiableMapView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_values);
  }

  // locale -> translated text
  @override
  final String? description;

  @override
  String toString() {
    return 'LocalizationEntry(key: $key, values: $values, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$LocalizationEntryImplImpl &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    key,
    const DeepCollectionEquality().hash(_values),
    description,
  );

  /// Create a copy of LocalizationEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$$LocalizationEntryImplImplCopyWith<_$$LocalizationEntryImplImpl>
  get copyWith =>
      __$$$LocalizationEntryImplImplCopyWithImpl<_$$LocalizationEntryImplImpl>(
        this,
        _$identity,
      );
}

abstract class _$LocalizationEntryImpl implements LocalizationEntry {
  const factory _$LocalizationEntryImpl({
    required final String key,
    required final Map<String, String> values,
    final String? description,
  }) = _$$LocalizationEntryImplImpl;

  @override
  String get key;
  @override
  Map<String, String> get values; // locale -> translated text
  @override
  String? get description;

  /// Create a copy of LocalizationEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$$LocalizationEntryImplImplCopyWith<_$$LocalizationEntryImplImpl>
  get copyWith => throw _privateConstructorUsedError;
}
